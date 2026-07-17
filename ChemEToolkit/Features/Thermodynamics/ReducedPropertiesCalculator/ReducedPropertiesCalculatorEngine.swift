struct ReducedPropertiesCalculatorEngine:
    Sendable {

    func calculate(
        _ input:
            ReducedPropertiesCalculatorInput
    ) throws
        -> ReducedPropertiesCalculatorResult {

        let values = [
            input.temperatureKelvin,
            input.criticalTemperatureKelvin,
            input.absolutePressure,
            input.criticalPressure
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw ReducedPropertiesCalculatorError
                .nonFiniteInput
        }

        guard
            input.temperatureKelvin > 0,
            input.criticalTemperatureKelvin > 0
        else {
            throw ReducedPropertiesCalculatorError
                .nonPositiveTemperature
        }

        guard
            input.absolutePressure > 0,
            input.criticalPressure > 0
        else {
            throw ReducedPropertiesCalculatorError
                .nonPositivePressure
        }

        let reducedTemperature =
            input.temperatureKelvin
            / input.criticalTemperatureKelvin

        let reducedPressure =
            input.absolutePressure
            / input.criticalPressure

        let temperatureDistance =
            reducedTemperature - 1

        let pressureDistance =
            reducedPressure - 1

        let region: String

        if
            reducedTemperature >= 1,
            reducedPressure >= 1
        {
            region = "Above both critical ratios"
        } else if reducedTemperature >= 1 {
            region = "Above critical temperature ratio"
        } else if reducedPressure >= 1 {
            region = "Above critical pressure ratio"
        } else {
            region = "Below both critical ratios"
        }

        let outputs = [
            reducedTemperature,
            reducedPressure,
            temperatureDistance,
            pressureDistance
        ]

        guard outputs.allSatisfy(\.isFinite) else {
            throw ReducedPropertiesCalculatorError
                .numericalFailure
        }

        return .init(
            reducedTemperature:
                reducedTemperature,
            reducedPressure:
                reducedPressure,
            temperatureDistanceFromCritical:
                temperatureDistance,
            pressureDistanceFromCritical:
                pressureDistance,
            regionDescription:
                region,
            modelName:
                "Critical-property normalization",
            limitationDescription:
                "Reduced properties support corresponding-states analysis but do not by themselves determine phase or compressibility."
        )
    }
}
