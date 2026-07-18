import Testing
@testable import ChemEToolkit

@Suite("Psychrometric Air Enthalpy Engine")
struct PsychrometricAirEnthalpyEngineTests {
    private let engine =
        PsychrometricAirEnthalpyEngine()

    @Test("Calculates humid-air enthalpy")
    func enthalpy() throws {
        let result =
            try engine.calculate(
                .init(
                    dryBulbTemperatureC: 30,
                    humidityRatio: 0.012,
                    dryAirHeatCapacity: 1.005,
                    vaporHeatCapacity: 1.88,
                    referenceLatentHeat: 2500
                )
            )

        let expected =
            1.005 * 30
            + 0.012
                * (
                    2500
                    + 1.88 * 30
                )

        #expect(
            abs(
                result.humidAirEnthalpy
                - expected
            ) < 1e-12
        )
    }

    @Test("Higher humidity raises enthalpy")
    func humidityTrend() throws {
        let low =
            try engine.calculate(
                .init(
                    dryBulbTemperatureC: 30,
                    humidityRatio: 0.005,
                    dryAirHeatCapacity: 1.005,
                    vaporHeatCapacity: 1.88,
                    referenceLatentHeat: 2500
                )
            )

        let high =
            try engine.calculate(
                .init(
                    dryBulbTemperatureC: 30,
                    humidityRatio: 0.015,
                    dryAirHeatCapacity: 1.005,
                    vaporHeatCapacity: 1.88,
                    referenceLatentHeat: 2500
                )
            )

        #expect(
            high.humidAirEnthalpy
            > low.humidAirEnthalpy
        )
    }

    @Test("Rejects negative humidity ratio")
    func validation() {
        #expect(
            throws:
                PsychrometricAirEnthalpyError
                    .negativeHumidityRatio
        ) {
            try engine.calculate(
                .init(
                    dryBulbTemperatureC: 30,
                    humidityRatio: -0.01,
                    dryAirHeatCapacity: 1.005,
                    vaporHeatCapacity: 1.88,
                    referenceLatentHeat: 2500
                )
            )
        }
    }
}
