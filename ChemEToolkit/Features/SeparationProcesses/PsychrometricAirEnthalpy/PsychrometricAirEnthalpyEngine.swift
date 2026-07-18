struct PsychrometricAirEnthalpyEngine:
    Sendable {

    func calculate(
        _ input:
            PsychrometricAirEnthalpyInput
    ) throws
        -> PsychrometricAirEnthalpyResult {

        let values = [
            input.dryBulbTemperatureC,
            input.humidityRatio,
            input.dryAirHeatCapacity,
            input.vaporHeatCapacity,
            input.referenceLatentHeat
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw PsychrometricAirEnthalpyError
                .nonFiniteInput
        }

        guard input.humidityRatio >= 0 else {
            throw PsychrometricAirEnthalpyError
                .negativeHumidityRatio
        }

        guard
            input.dryAirHeatCapacity > 0,
            input.vaporHeatCapacity > 0,
            input.referenceLatentHeat > 0
        else {
            throw PsychrometricAirEnthalpyError
                .nonPositiveProperty
        }

        let drySensible =
            input.dryAirHeatCapacity
            * input.dryBulbTemperatureC

        let vaporLatent =
            input.humidityRatio
            * input.referenceLatentHeat

        let vaporSensible =
            input.humidityRatio
            * input.vaporHeatCapacity
            * input.dryBulbTemperatureC

        let enthalpy =
            drySensible
            + vaporLatent
            + vaporSensible

        let humidHeat =
            input.dryAirHeatCapacity
            + input.humidityRatio
                * input.vaporHeatCapacity

        let outputs = [
            drySensible,
            vaporLatent,
            vaporSensible,
            enthalpy,
            humidHeat
        ]

        guard outputs.allSatisfy(\.isFinite) else {
            throw PsychrometricAirEnthalpyError
                .numericalFailure
        }

        return .init(
            humidAirEnthalpy:
                enthalpy,
            dryAirSensibleContribution:
                drySensible,
            vaporLatentContribution:
                vaporLatent,
            vaporSensibleContribution:
                vaporSensible,
            humidHeat:
                humidHeat,
            modelName:
                "Ideal humid-air enthalpy relation",
            limitationDescription:
                "Uses h = cpaT + w(lambda0 + cpvT) relative to liquid water at the reference temperature."
        )
    }
}
