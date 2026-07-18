struct PsychrometricAirStreamMixingEngine:
    Sendable {

    private let dryAirHeatCapacity =
        1.005

    private let vaporHeatCapacity =
        1.88

    private let referenceLatentHeat =
        2500.0

    func calculate(
        _ input:
            PsychrometricAirStreamMixingInput
    ) throws
        -> PsychrometricAirStreamMixingResult {

        let values = [
            input.dryAirFlow1,
            input.temperature1C,
            input.humidityRatio1,
            input.dryAirFlow2,
            input.temperature2C,
            input.humidityRatio2
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw PsychrometricAirStreamMixingError
                .nonFiniteInput
        }

        guard
            input.dryAirFlow1 > 0,
            input.dryAirFlow2 > 0
        else {
            throw PsychrometricAirStreamMixingError
                .nonPositiveFlow
        }

        guard
            input.humidityRatio1 >= 0,
            input.humidityRatio2 >= 0
        else {
            throw PsychrometricAirStreamMixingError
                .negativeHumidityRatio
        }

        func enthalpy(
            temperature: Double,
            humidityRatio: Double
        ) -> Double {
            dryAirHeatCapacity
            * temperature
            + humidityRatio
                * (
                    referenceLatentHeat
                    + vaporHeatCapacity
                        * temperature
                )
        }

        let flow =
            input.dryAirFlow1
            + input.dryAirFlow2

        let humidity =
            (
                input.dryAirFlow1
                    * input.humidityRatio1
                + input.dryAirFlow2
                    * input.humidityRatio2
            )
            / flow

        let enthalpy1 =
            enthalpy(
                temperature:
                    input.temperature1C,
                humidityRatio:
                    input.humidityRatio1
            )

        let enthalpy2 =
            enthalpy(
                temperature:
                    input.temperature2C,
                humidityRatio:
                    input.humidityRatio2
            )

        let mixedEnthalpy =
            (
                input.dryAirFlow1
                    * enthalpy1
                + input.dryAirFlow2
                    * enthalpy2
            )
            / flow

        let denominator =
            dryAirHeatCapacity
            + humidity
                * vaporHeatCapacity

        let temperature =
            (
                mixedEnthalpy
                - humidity
                    * referenceLatentHeat
            )
            / denominator

        let vaporFlow =
            flow * humidity

        let outputs = [
            flow,
            humidity,
            mixedEnthalpy,
            temperature,
            vaporFlow
        ]

        guard outputs.allSatisfy(\.isFinite) else {
            throw PsychrometricAirStreamMixingError
                .numericalFailure
        }

        return .init(
            mixedDryAirFlow:
                flow,
            mixedHumidityRatio:
                humidity,
            mixedTemperatureC:
                temperature,
            mixedEnthalpy:
                mixedEnthalpy,
            mixedWaterVaporFlow:
                vaporFlow,
            modelName:
                "Adiabatic humid-air stream mixing",
            limitationDescription:
                "Uses ideal humid-air enthalpy and neglects condensation, heat loss and pressure change."
        )
    }
}
