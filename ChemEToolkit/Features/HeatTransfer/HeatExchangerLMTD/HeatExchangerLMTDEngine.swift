import Foundation

struct HeatExchangerLMTDEngine {

    func calculate(
        input: HeatExchangerLMTDInput
    ) throws -> HeatExchangerLMTDResult {

        try validateBaseInputs(input)

        let temperatureDifferences =
            terminalTemperatureDifferences(
                for: input
            )

        guard
            temperatureDifferences.first > 0,
            temperatureDifferences.second > 0
        else {
            throw HeatExchangerLMTDError
                .nonPositiveTerminalTemperatureDifference
        }

        let lmtd =
            calculateLMTD(
                deltaTOne:
                    temperatureDifferences.first,
                deltaTTwo:
                    temperatureDifferences.second
            )

        let correctedLMTD =
            input.correctionFactor
            * lmtd

        let overallConductance =
            input.overallHeatTransferCoefficient
            * input.heatTransferArea

        let heatTransferRate =
            overallConductance
            * correctedLMTD

        let heatFlux =
            heatTransferRate
            / input.heatTransferArea

        return HeatExchangerLMTDResult(
            flowArrangement:
                input.flowArrangement,
            terminalTemperatureDifferenceOne:
                temperatureDifferences.first,
            terminalTemperatureDifferenceTwo:
                temperatureDifferences.second,
            logMeanTemperatureDifference:
                lmtd,
            correctionFactor:
                input.correctionFactor,
            correctedLogMeanTemperatureDifference:
                correctedLMTD,
            overallConductance:
                overallConductance,
            heatTransferRate:
                heatTransferRate,
            heatFlux:
                heatFlux
        )
    }

    private func validateBaseInputs(
        _ input: HeatExchangerLMTDInput
    ) throws {

        let values = [
            input.hotInletTemperature,
            input.hotOutletTemperature,
            input.coldInletTemperature,
            input.coldOutletTemperature,
            input.overallHeatTransferCoefficient,
            input.heatTransferArea,
            input.correctionFactor
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw HeatExchangerLMTDError
                .nonFiniteInput
        }

        guard
            input.overallHeatTransferCoefficient > 0
        else {
            throw HeatExchangerLMTDError
                .nonPositiveOverallCoefficient
        }

        guard input.heatTransferArea > 0 else {
            throw HeatExchangerLMTDError
                .nonPositiveArea
        }

        guard
            input.correctionFactor > 0,
            input.correctionFactor <= 1
        else {
            throw HeatExchangerLMTDError
                .invalidCorrectionFactor
        }

        guard
            input.hotInletTemperature
                >= input.hotOutletTemperature
        else {
            throw HeatExchangerLMTDError
                .invalidHotStreamTemperatureOrder
        }

        guard
            input.coldOutletTemperature
                >= input.coldInletTemperature
        else {
            throw HeatExchangerLMTDError
                .invalidColdStreamTemperatureOrder
        }
    }

    private func terminalTemperatureDifferences(
        for input: HeatExchangerLMTDInput
    ) -> (
        first: Double,
        second: Double
    ) {
        switch input.flowArrangement {
        case .parallelFlow:
            return (
                first:
                    input.hotInletTemperature
                    - input.coldInletTemperature,
                second:
                    input.hotOutletTemperature
                    - input.coldOutletTemperature
            )

        case .counterFlow:
            return (
                first:
                    input.hotInletTemperature
                    - input.coldOutletTemperature,
                second:
                    input.hotOutletTemperature
                    - input.coldInletTemperature
            )
        }
    }

    private func calculateLMTD(
        deltaTOne: Double,
        deltaTTwo: Double
    ) -> Double {

        let comparisonScale =
            max(
                max(
                    abs(deltaTOne),
                    abs(deltaTTwo)
                ),
                1
            )

        let differencesAreNearlyEqual =
            abs(deltaTOne - deltaTTwo)
            <= 1e-12 * comparisonScale

        if differencesAreNearlyEqual {
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
