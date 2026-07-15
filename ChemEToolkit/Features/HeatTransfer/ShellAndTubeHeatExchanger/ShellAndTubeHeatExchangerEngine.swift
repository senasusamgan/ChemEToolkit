import Foundation

struct ShellAndTubeHeatExchangerEngine {

    func calculate(
        input: ShellAndTubeHeatExchangerInput
    ) throws -> ShellAndTubeHeatExchangerResult {

        try validate(input)

        let deltaTOne =
            input.hotInletTemperature
            - input.coldOutletTemperature

        let deltaTTwo =
            input.hotOutletTemperature
            - input.coldInletTemperature

        guard
            deltaTOne > 0,
            deltaTTwo > 0
        else {
            throw ShellAndTubeHeatExchangerError
                .nonPositiveTerminalTemperatureDifference
        }

        let lmtd =
            calculateLMTD(
                deltaTOne: deltaTOne,
                deltaTTwo: deltaTTwo
            )

        let correctedLMTD =
            input.correctionFactor
            * lmtd

        let requiredOverallConductance =
            input.requiredHeatTransferRate
            / correctedLMTD

        let requiredArea =
            requiredOverallConductance
            / input.overallHeatTransferCoefficient

        let areaPerTube =
            Double.pi
            * input.tubeOuterDiameter
            * input.tubeLength

        let exactTubeCount =
            requiredArea
            / areaPerTube

        let selectedTubeCount =
            roundedTubeCount(
                exactTubeCount:
                    exactTubeCount,
                numberOfPasses:
                    input.numberOfTubePasses
            )

        let tubesPerPass =
            selectedTubeCount
            / input.numberOfTubePasses

        let providedArea =
            Double(selectedTubeCount)
            * areaPerTube

        let areaDesignMarginPercentage =
            (
                providedArea
                - requiredArea
            )
            / requiredArea
            * 100

        let providedHeatTransferRate =
            input.overallHeatTransferCoefficient
            * providedArea
            * correctedLMTD

        return ShellAndTubeHeatExchangerResult(
            terminalTemperatureDifferenceOne:
                deltaTOne,
            terminalTemperatureDifferenceTwo:
                deltaTTwo,
            logMeanTemperatureDifference:
                lmtd,
            correctedLogMeanTemperatureDifference:
                correctedLMTD,
            requiredHeatTransferArea:
                requiredArea,
            heatTransferAreaPerTube:
                areaPerTube,
            exactTubeCount:
                exactTubeCount,
            selectedTubeCount:
                selectedTubeCount,
            numberOfTubePasses:
                input.numberOfTubePasses,
            tubesPerPass:
                tubesPerPass,
            providedHeatTransferArea:
                providedArea,
            areaDesignMarginPercentage:
                areaDesignMarginPercentage,
            requiredOverallConductance:
                requiredOverallConductance,
            providedHeatTransferRate:
                providedHeatTransferRate
        )
    }

    private func roundedTubeCount(
        exactTubeCount: Double,
        numberOfPasses: Int
    ) -> Int {

        let groups =
            ceil(
                exactTubeCount
                / Double(numberOfPasses)
            )

        return Int(groups)
            * numberOfPasses
    }

    private func calculateLMTD(
        deltaTOne: Double,
        deltaTTwo: Double
    ) -> Double {

        let scale =
            max(
                max(
                    abs(deltaTOne),
                    abs(deltaTTwo)
                ),
                1
            )

        if abs(deltaTOne - deltaTTwo)
            <= 1e-12 * scale {
            return (
                deltaTOne
                + deltaTTwo
            ) / 2
        }

        return (
            deltaTOne
            - deltaTTwo
        ) / log(
            deltaTOne
            / deltaTTwo
        )
    }

    private func validate(
        _ input: ShellAndTubeHeatExchangerInput
    ) throws {

        let values = [
            input.hotInletTemperature,
            input.hotOutletTemperature,
            input.coldInletTemperature,
            input.coldOutletTemperature,
            input.requiredHeatTransferRate,
            input.overallHeatTransferCoefficient,
            input.correctionFactor,
            input.tubeOuterDiameter,
            input.tubeLength
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw ShellAndTubeHeatExchangerError
                .nonFiniteInput
        }

        guard input.requiredHeatTransferRate > 0 else {
            throw ShellAndTubeHeatExchangerError
                .nonPositiveHeatTransferRate
        }

        guard
            input.overallHeatTransferCoefficient > 0
        else {
            throw ShellAndTubeHeatExchangerError
                .nonPositiveOverallCoefficient
        }

        guard
            input.correctionFactor > 0,
            input.correctionFactor <= 1
        else {
            throw ShellAndTubeHeatExchangerError
                .invalidCorrectionFactor
        }

        guard input.tubeOuterDiameter > 0 else {
            throw ShellAndTubeHeatExchangerError
                .nonPositiveTubeDiameter
        }

        guard input.tubeLength > 0 else {
            throw ShellAndTubeHeatExchangerError
                .nonPositiveTubeLength
        }

        guard input.numberOfTubePasses > 0 else {
            throw ShellAndTubeHeatExchangerError
                .nonPositiveTubePassCount
        }

        guard
            input.hotInletTemperature
                >= input.hotOutletTemperature
        else {
            throw ShellAndTubeHeatExchangerError
                .invalidHotStreamTemperatureOrder
        }

        guard
            input.coldOutletTemperature
                >= input.coldInletTemperature
        else {
            throw ShellAndTubeHeatExchangerError
                .invalidColdStreamTemperatureOrder
        }
    }
}
