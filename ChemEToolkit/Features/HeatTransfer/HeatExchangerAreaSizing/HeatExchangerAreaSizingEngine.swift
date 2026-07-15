import Foundation

struct HeatExchangerAreaSizingEngine {

    func calculate(
        input: HeatExchangerAreaSizingInput
    ) throws -> HeatExchangerAreaSizingResult {

        try validate(input)

        let differences =
            terminalTemperatureDifferences(
                for: input
            )

        guard
            differences.first > 0,
            differences.second > 0
        else {
            throw HeatExchangerAreaSizingError
                .nonPositiveTerminalTemperatureDifference
        }

        let lmtd =
            calculateLMTD(
                deltaTOne: differences.first,
                deltaTTwo: differences.second
            )

        let correctedLMTD =
            input.correctionFactor * lmtd

        let requiredOverallConductance =
            input.requiredHeatTransferRate
            / correctedLMTD

        let requiredArea =
            requiredOverallConductance
            / input.overallHeatTransferCoefficient

        let designHeatFlux =
            input.requiredHeatTransferRate
            / requiredArea

        return HeatExchangerAreaSizingResult(
            flowArrangement:
                input.flowArrangement,
            terminalTemperatureDifferenceOne:
                differences.first,
            terminalTemperatureDifferenceTwo:
                differences.second,
            logMeanTemperatureDifference:
                lmtd,
            correctionFactor:
                input.correctionFactor,
            correctedLogMeanTemperatureDifference:
                correctedLMTD,
            requiredArea:
                requiredArea,
            designHeatFlux:
                designHeatFlux,
            requiredOverallConductance:
                requiredOverallConductance
        )
    }

    private func validate(
        _ input: HeatExchangerAreaSizingInput
    ) throws {

        let values = [
            input.hotInletTemperature,
            input.hotOutletTemperature,
            input.coldInletTemperature,
            input.coldOutletTemperature,
            input.requiredHeatTransferRate,
            input.overallHeatTransferCoefficient,
            input.correctionFactor
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw HeatExchangerAreaSizingError
                .nonFiniteInput
        }

        guard input.requiredHeatTransferRate > 0 else {
            throw HeatExchangerAreaSizingError
                .nonPositiveHeatTransferRate
        }

        guard
            input.overallHeatTransferCoefficient > 0
        else {
            throw HeatExchangerAreaSizingError
                .nonPositiveOverallCoefficient
        }

        guard
            input.correctionFactor > 0,
            input.correctionFactor <= 1
        else {
            throw HeatExchangerAreaSizingError
                .invalidCorrectionFactor
        }

        guard
            input.hotInletTemperature
                >= input.hotOutletTemperature
        else {
            throw HeatExchangerAreaSizingError
                .invalidHotStreamTemperatureOrder
        }

        guard
            input.coldOutletTemperature
                >= input.coldInletTemperature
        else {
            throw HeatExchangerAreaSizingError
                .invalidColdStreamTemperatureOrder
        }
    }

    private func terminalTemperatureDifferences(
        for input: HeatExchangerAreaSizingInput
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
