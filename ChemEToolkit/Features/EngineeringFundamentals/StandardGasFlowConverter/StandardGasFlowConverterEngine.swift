struct StandardGasFlowConverterEngine:
    Sendable {

    func calculate(
        _ input:
            StandardGasFlowConverterInput
    ) throws
        -> StandardGasFlowConverterResult {

        let values = [
            input.actualVolumetricFlowRate,
            input.actualAbsolutePressure,
            input.actualTemperatureKelvin,
            input.standardAbsolutePressure,
            input.standardTemperatureKelvin
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw StandardGasFlowConverterError
                .nonFiniteInput
        }

        guard
            input.actualVolumetricFlowRate >= 0
        else {
            throw StandardGasFlowConverterError
                .negativeFlowRate
        }

        guard
            input.actualAbsolutePressure > 0,
            input.standardAbsolutePressure > 0
        else {
            throw StandardGasFlowConverterError
                .nonPositivePressure
        }

        guard
            input.actualTemperatureKelvin > 0,
            input.standardTemperatureKelvin > 0
        else {
            throw StandardGasFlowConverterError
                .nonPositiveTemperature
        }

        let pressureFactor =
            input.actualAbsolutePressure
            / input.standardAbsolutePressure

        let temperatureFactor =
            input.standardTemperatureKelvin
            / input.actualTemperatureKelvin

        let ratio =
            pressureFactor
            * temperatureFactor

        let standardFlow =
            input.actualVolumetricFlowRate
            * ratio

        let densityRatio =
            ratio

        let results = [
            pressureFactor,
            temperatureFactor,
            ratio,
            standardFlow,
            densityRatio
        ]

        guard
            results.allSatisfy(\.isFinite),
            results.allSatisfy({ $0 >= 0 })
        else {
            throw StandardGasFlowConverterError
                .numericalFailure
        }

        return .init(
            standardVolumetricFlowRate:
                standardFlow,
            standardToActualFlowRatio:
                ratio,
            pressureCorrectionFactor:
                pressureFactor,
            temperatureCorrectionFactor:
                temperatureFactor,
            actualToStandardDensityRatio:
                densityRatio,
            modelName:
                "Ideal-gas pressure–temperature flow correction",
            limitationDescription:
                "Uses absolute pressure and kelvin. Assumes ideal-gas behavior and unchanged composition; include compressibility factors for real-gas correction."
        )
    }
}
