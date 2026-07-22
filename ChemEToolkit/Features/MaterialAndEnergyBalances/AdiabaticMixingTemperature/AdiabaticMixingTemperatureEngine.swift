struct AdiabaticMixingTemperatureEngine:
    Sendable {

    func calculate(
        _ input:
            AdiabaticMixingTemperatureInput
    ) throws
        -> AdiabaticMixingTemperatureResult {

        let values = [
            input.stream1MassFlow,
            input.stream1HeatCapacity,
            input.stream1Temperature,
            input.stream2MassFlow,
            input.stream2HeatCapacity,
            input.stream2Temperature
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw AdiabaticMixingTemperatureError
                .nonFiniteInput
        }

        guard
            input.stream1MassFlow >= 0,
            input.stream2MassFlow >= 0
        else {
            throw AdiabaticMixingTemperatureError
                .negativeMassFlow
        }

        guard
            input.stream1HeatCapacity > 0,
            input.stream2HeatCapacity > 0
        else {
            throw AdiabaticMixingTemperatureError
                .nonPositiveHeatCapacity
        }

        let capacity1 =
            input.stream1MassFlow
            * input.stream1HeatCapacity

        let capacity2 =
            input.stream2MassFlow
            * input.stream2HeatCapacity

        let totalCapacity =
            capacity1 + capacity2

        guard totalCapacity > 0 else {
            throw AdiabaticMixingTemperatureError
                .zeroTotalCapacityRate
        }

        let mixedTemperature =
            (
                capacity1 * input.stream1Temperature
                + capacity2 * input.stream2Temperature
            )
            / totalCapacity

        let totalFlow =
            input.stream1MassFlow
            + input.stream2MassFlow

        let outputs = [
            capacity1,
            capacity2,
            totalCapacity,
            mixedTemperature,
            totalFlow
        ]

        guard outputs.allSatisfy(\.isFinite) else {
            throw AdiabaticMixingTemperatureError
                .numericalFailure
        }

        return .init(
            mixedTemperature:
                mixedTemperature,
            totalMassFlow:
                totalFlow,
            stream1HeatCapacityRate:
                capacity1,
            stream2HeatCapacityRate:
                capacity2,
            totalHeatCapacityRate:
                totalCapacity,
            modelName:
                "Adiabatic two-stream sensible-energy balance",
            limitationDescription:
                "Assumes constant heat capacities, no phase change, no reaction, no heat loss and negligible kinetic and potential energy changes."
        )
    }
}
