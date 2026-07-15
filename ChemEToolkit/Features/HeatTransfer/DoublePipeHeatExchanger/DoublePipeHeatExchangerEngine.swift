import Foundation

struct DoublePipeHeatExchangerEngine {

    func calculate(
        input: DoublePipeHeatExchangerInput
    ) throws -> DoublePipeHeatExchangerResult {

        try validate(input)

        let differences =
            terminalTemperatureDifferences(
                for: input
            )

        guard
            differences.first > 0,
            differences.second > 0
        else {
            throw DoublePipeHeatExchangerError
                .nonPositiveTerminalTemperatureDifference
        }

        let lmtd =
            calculateLMTD(
                deltaTOne: differences.first,
                deltaTTwo: differences.second
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

        let requiredLengthPerTube =
            requiredArea
            / (
                Double(input.numberOfParallelTubes)
                * Double.pi
                * input.tubeOuterDiameter
            )

        let totalTubeLength =
            requiredLengthPerTube
            * Double(input.numberOfParallelTubes)

        let designHeatFlux =
            input.requiredHeatTransferRate
            / requiredArea

        return DoublePipeHeatExchangerResult(
            flowArrangement:
                input.flowArrangement,
            terminalTemperatureDifferenceOne:
                differences.first,
            terminalTemperatureDifferenceTwo:
                differences.second,
            logMeanTemperatureDifference:
                lmtd,
            correctedLogMeanTemperatureDifference:
                correctedLMTD,
            requiredHeatTransferArea:
                requiredArea,
            requiredLengthPerTube:
                requiredLengthPerTube,
            totalTubeLength:
                totalTubeLength,
            numberOfParallelTubes:
                input.numberOfParallelTubes,
            requiredOverallConductance:
                requiredOverallConductance,
            designHeatFlux:
                designHeatFlux
        )
    }

    private func validate(
        _ input: DoublePipeHeatExchangerInput
    ) throws {

        let values = [
            input.hotInletTemperature,
            input.hotOutletTemperature,
            input.coldInletTemperature,
            input.coldOutletTemperature,
            input.requiredHeatTransferRate,
            input.overallHeatTransferCoefficient,
            input.tubeOuterDiameter,
            input.correctionFactor
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw DoublePipeHeatExchangerError
                .nonFiniteInput
        }

        guard input.requiredHeatTransferRate > 0 else {
            throw DoublePipeHeatExchangerError
                .nonPositiveHeatTransferRate
        }

        guard
            input.overallHeatTransferCoefficient > 0
        else {
            throw DoublePipeHeatExchangerError
                .nonPositiveOverallCoefficient
        }

        guard input.tubeOuterDiameter > 0 else {
            throw DoublePipeHeatExchangerError
                .nonPositiveTubeDiameter
        }

        guard input.numberOfParallelTubes > 0 else {
            throw DoublePipeHeatExchangerError
                .nonPositiveParallelTubeCount
        }

        guard
            input.correctionFactor > 0,
            input.correctionFactor <= 1
        else {
            throw DoublePipeHeatExchangerError
                .invalidCorrectionFactor
        }

        guard
            input.hotInletTemperature
                >= input.hotOutletTemperature
        else {
            throw DoublePipeHeatExchangerError
                .invalidHotStreamTemperatureOrder
        }

        guard
            input.coldOutletTemperature
                >= input.coldInletTemperature
        else {
            throw DoublePipeHeatExchangerError
                .invalidColdStreamTemperatureOrder
        }
    }

    private func terminalTemperatureDifferences(
        for input: DoublePipeHeatExchangerInput
    ) -> (
        first: Double,
        second: Double
    ) {
        switch input.flowArrangement {
        case .parallelFlow:
            return (
                input.hotInletTemperature
                    - input.coldInletTemperature,
                input.hotOutletTemperature
                    - input.coldOutletTemperature
            )

        case .counterFlow:
            return (
                input.hotInletTemperature
                    - input.coldOutletTemperature,
                input.hotOutletTemperature
                    - input.coldInletTemperature
            )
        }
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
}
