import Testing
@testable import ChemEToolkit

@Suite("Relative Humidity Humidification Engine")
struct RelativeHumidityHumidificationEngineTests {
    private let engine =
        RelativeHumidityHumidificationEngine()

    @Test("Calculates positive water demand")
    func humidification() throws {
        let result =
            try engine.calculate(
                .init(
                    dryAirMassFlow: 1000,
                    dryBulbTemperatureC: 25,
                    totalPressureKPa: 101.325,
                    inletRelativeHumidityPercent: 30,
                    outletRelativeHumidityPercent: 60
                )
            )

        #expect(
            result.requiredWaterFlow
            > 0
        )

        #expect(
            result.outletHumidityRatio
            > result.inletHumidityRatio
        )
    }

    @Test("Larger humidity target requires more water")
    func targetTrend() throws {
        let low =
            try engine.calculate(
                .init(
                    dryAirMassFlow: 1000,
                    dryBulbTemperatureC: 25,
                    totalPressureKPa: 101.325,
                    inletRelativeHumidityPercent: 30,
                    outletRelativeHumidityPercent: 50
                )
            )

        let high =
            try engine.calculate(
                .init(
                    dryAirMassFlow: 1000,
                    dryBulbTemperatureC: 25,
                    totalPressureKPa: 101.325,
                    inletRelativeHumidityPercent: 30,
                    outletRelativeHumidityPercent: 70
                )
            )

        #expect(
            high.requiredWaterFlow
            > low.requiredWaterFlow
        )
    }

    @Test("Rejects outlet humidity below inlet")
    func validation() {
        #expect(
            throws:
                RelativeHumidityHumidificationError
                    .outletBelowInlet
        ) {
            try engine.calculate(
                .init(
                    dryAirMassFlow: 1000,
                    dryBulbTemperatureC: 25,
                    totalPressureKPa: 101.325,
                    inletRelativeHumidityPercent: 60,
                    outletRelativeHumidityPercent: 30
                )
            )
        }
    }
}
