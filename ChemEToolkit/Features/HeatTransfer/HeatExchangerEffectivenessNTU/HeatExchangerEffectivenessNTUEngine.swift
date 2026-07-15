import Foundation

struct HeatExchangerEffectivenessNTUEngine {

    func calculate(
        input:
            HeatExchangerEffectivenessNTUInput
    ) throws
        -> HeatExchangerEffectivenessNTUResult {

        try validate(input)

        let hotCapacityRate =
            input.hotMassFlowRate
            * input.hotSpecificHeatCapacity

        let coldCapacityRate =
            input.coldMassFlowRate
            * input.coldSpecificHeatCapacity

        let minimumCapacityRate =
            min(
                hotCapacityRate,
                coldCapacityRate
            )

        let maximumCapacityRate =
            max(
                hotCapacityRate,
                coldCapacityRate
            )

        let capacityRateRatio =
            minimumCapacityRate
            / maximumCapacityRate

        let numberOfTransferUnits =
            input.overallHeatTransferCoefficient
            * input.heatTransferArea
            / minimumCapacityRate

        let effectiveness =
            calculateEffectiveness(
                arrangement:
                    input.flowArrangement,
                numberOfTransferUnits:
                    numberOfTransferUnits,
                capacityRateRatio:
                    capacityRateRatio
            )

        let maximumPossibleHeatTransferRate =
            minimumCapacityRate
            * (
                input.hotInletTemperature
                - input.coldInletTemperature
            )

        let actualHeatTransferRate =
            effectiveness
            * maximumPossibleHeatTransferRate

        let hotOutletTemperature =
            input.hotInletTemperature
            - actualHeatTransferRate
            / hotCapacityRate

        let coldOutletTemperature =
            input.coldInletTemperature
            + actualHeatTransferRate
            / coldCapacityRate

        return HeatExchangerEffectivenessNTUResult(
            flowArrangement:
                input.flowArrangement,
            hotCapacityRate:
                hotCapacityRate,
            coldCapacityRate:
                coldCapacityRate,
            minimumCapacityRate:
                minimumCapacityRate,
            maximumCapacityRate:
                maximumCapacityRate,
            capacityRateRatio:
                capacityRateRatio,
            numberOfTransferUnits:
                numberOfTransferUnits,
            effectiveness:
                effectiveness,
            maximumPossibleHeatTransferRate:
                maximumPossibleHeatTransferRate,
            actualHeatTransferRate:
                actualHeatTransferRate,
            hotOutletTemperature:
                hotOutletTemperature,
            coldOutletTemperature:
                coldOutletTemperature
        )
    }

    private func calculateEffectiveness(
        arrangement:
            HeatExchangerNTUArrangement,
        numberOfTransferUnits: Double,
        capacityRateRatio: Double
    ) -> Double {

        switch arrangement {
        case .parallelFlow:
            return (
                1
                - exp(
                    -numberOfTransferUnits
                    * (
                        1
                        + capacityRateRatio
                    )
                )
            ) / (
                1
                + capacityRateRatio
            )

        case .counterFlow:
            let equalCapacityRates =
                abs(capacityRateRatio - 1)
                <= 1e-12

            if equalCapacityRates {
                return numberOfTransferUnits
                    / (
                        1
                        + numberOfTransferUnits
                    )
            }

            let exponentialTerm =
                exp(
                    -numberOfTransferUnits
                    * (
                        1
                        - capacityRateRatio
                    )
                )

            return (
                1
                - exponentialTerm
            ) / (
                1
                - capacityRateRatio
                * exponentialTerm
            )
        }
    }

    private func validate(
        _ input:
            HeatExchangerEffectivenessNTUInput
    ) throws {

        let values = [
            input.hotInletTemperature,
            input.coldInletTemperature,
            input.hotMassFlowRate,
            input.coldMassFlowRate,
            input.hotSpecificHeatCapacity,
            input.coldSpecificHeatCapacity,
            input.overallHeatTransferCoefficient,
            input.heatTransferArea
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw HeatExchangerEffectivenessNTUError
                .nonFiniteInput
        }

        guard
            input.hotInletTemperature
                > input.coldInletTemperature
        else {
            throw HeatExchangerEffectivenessNTUError
                .invalidInletTemperatureOrder
        }

        guard input.hotMassFlowRate > 0 else {
            throw HeatExchangerEffectivenessNTUError
                .nonPositiveHotMassFlowRate
        }

        guard input.coldMassFlowRate > 0 else {
            throw HeatExchangerEffectivenessNTUError
                .nonPositiveColdMassFlowRate
        }

        guard input.hotSpecificHeatCapacity > 0 else {
            throw HeatExchangerEffectivenessNTUError
                .nonPositiveHotSpecificHeat
        }

        guard input.coldSpecificHeatCapacity > 0 else {
            throw HeatExchangerEffectivenessNTUError
                .nonPositiveColdSpecificHeat
        }

        guard
            input.overallHeatTransferCoefficient > 0
        else {
            throw HeatExchangerEffectivenessNTUError
                .nonPositiveOverallCoefficient
        }

        guard input.heatTransferArea > 0 else {
            throw HeatExchangerEffectivenessNTUError
                .nonPositiveArea
        }
    }
}
