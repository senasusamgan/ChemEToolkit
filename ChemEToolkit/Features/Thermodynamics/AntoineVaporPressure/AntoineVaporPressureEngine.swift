import Foundation

struct AntoineVaporPressureEngine:
    Sendable {

    func calculate(
        _ input:
            AntoineVaporPressureInput
    ) throws
        -> AntoineVaporPressureResult {

        let values = [
            input.temperatureCelsius,
            input.coefficientA,
            input.coefficientB,
            input.coefficientC
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw AntoineVaporPressureError
                .nonFiniteInput
        }

        let denominator =
            input.coefficientC
            + input.temperatureCelsius

        guard abs(denominator) > 1e-12 else {
            throw AntoineVaporPressureError
                .singularDenominator
        }

        let log10Pressure =
            input.coefficientA
            - input.coefficientB
                / denominator

        let pressure =
            Foundation.pow(
                10,
                log10Pressure
            )

        let naturalLogPressure =
            Foundation.log(pressure)

        let outputs = [
            denominator,
            log10Pressure,
            pressure,
            naturalLogPressure
        ]

        guard
            outputs.allSatisfy(\.isFinite),
            pressure > 0
        else {
            throw AntoineVaporPressureError
                .numericalFailure
        }

        return .init(
            denominator:
                denominator,
            log10Pressure:
                log10Pressure,
            vaporPressure:
                pressure,
            naturalLogPressure:
                naturalLogPressure,
            modelName:
                "Antoine vapor-pressure correlation",
            limitationDescription:
                "Uses log₁₀(Psat) = A − B/(C + T). Temperature and pressure units must match the selected Antoine coefficient set and its validity range."
        )
    }
}
