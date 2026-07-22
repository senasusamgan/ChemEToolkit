struct HeatExchangerEnergyBalanceEngine:
    Sendable {

    func calculate(
        _ input:
            HeatExchangerEnergyBalanceInput
    ) throws
        -> HeatExchangerEnergyBalanceResult {

        let values = [
            input.hotMassFlow,
            input.hotHeatCapacity,
            input.hotInletTemperature,
            input.hotOutletTemperature,
            input.coldMassFlow,
            input.coldHeatCapacity,
            input.coldInletTemperature
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw HeatExchangerEnergyBalanceError
                .nonFiniteInput
        }

        guard
            input.hotMassFlow > 0,
            input.hotHeatCapacity > 0,
            input.coldMassFlow > 0,
            input.coldHeatCapacity > 0
        else {
            throw HeatExchangerEnergyBalanceError
                .nonPositiveFlowOrHeatCapacity
        }

        guard
            input.hotOutletTemperature
            <= input.hotInletTemperature
        else {
            throw HeatExchangerEnergyBalanceError
                .invalidHotTemperatureChange
        }

        guard
            input.hotInletTemperature
            > input.coldInletTemperature
        else {
            throw HeatExchangerEnergyBalanceError
                .invalidInletTemperatureOrdering
        }

        let hotCapacityRate =
            input.hotMassFlow
            * input.hotHeatCapacity

        let coldCapacityRate =
            input.coldMassFlow
            * input.coldHeatCapacity

        let duty =
            hotCapacityRate
            * (
                input.hotInletTemperature
                - input.hotOutletTemperature
            )

        let coldRise =
            duty
            / coldCapacityRate

        let coldOutlet =
            input.coldInletTemperature
            + coldRise

        let minimumCapacityRate =
            min(
                hotCapacityRate,
                coldCapacityRate
            )

        let maximumDuty =
            minimumCapacityRate
            * (
                input.hotInletTemperature
                - input.coldInletTemperature
            )

        let tolerance =
            max(
                1e-12,
                maximumDuty * 1e-12
            )

        guard duty <= maximumDuty + tolerance else {
            throw HeatExchangerEnergyBalanceError
                .dutyExceedsThermodynamicMaximum
        }

        let effectiveness =
            maximumDuty > 0
            ? duty / maximumDuty
            : 0

        let outputs = [
            hotCapacityRate,
            coldCapacityRate,
            duty,
            coldRise,
            coldOutlet,
            minimumCapacityRate,
            maximumDuty,
            effectiveness
        ]

        guard
            outputs.allSatisfy(\.isFinite),
            duty >= 0,
            effectiveness >= 0,
            effectiveness <= 1 + 1e-12
        else {
            throw HeatExchangerEnergyBalanceError
                .numericalFailure
        }

        return .init(
            heatDuty:
                duty,
            coldOutletTemperature:
                coldOutlet,
            hotCapacityRate:
                hotCapacityRate,
            coldCapacityRate:
                coldCapacityRate,
            minimumCapacityRate:
                minimumCapacityRate,
            maximumPossibleDuty:
                maximumDuty,
            effectiveness:
                min(1, effectiveness),
            coldTemperatureRise:
                coldRise,
            modelName:
                "Adiabatic two-stream heat-exchanger energy balance",
            limitationDescription:
                "Uses constant heat capacities and no heat loss. It solves the cold outlet temperature from the entered hot-side temperature drop."
        )
    }
}
