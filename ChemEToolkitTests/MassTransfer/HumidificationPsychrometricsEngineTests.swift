import Testing
@testable import ChemEToolkit

@Suite(
    "Humidification and Psychrometrics Engine"
)
struct HumidificationPsychrometricsEngineTests {
    private let engine =
        HumidificationPsychrometricsEngine()

    @Test(
        "Calculates humidity ratios, water addition and heat duty"
    )
    func humidification() throws {
        let result = try engine.calculate(
            .init(
                dryAirMassFlowRate: 1000,
                dryBulbTemperatureCelsius:
                    25,
                totalPressureKPa: 101.325,
                inletRelativeHumidity: 0.3,
                outletRelativeHumidity: 0.6
            )
        )

        #expect(
            abs(
                result
                    .saturationVaporPressureKPa
                - 3.1617360356966913
            ) < 1e-12
        )
        #expect(
            abs(
                result.inletHumidityRatio
                - 0.005877482240956408
            ) < 1e-14
        )
        #expect(
            abs(
                result.outletHumidityRatio
                - 0.011867104252477001
            ) < 1e-14
        )
        #expect(
            abs(
                result.signedWaterTransferRate
                - 5.989622011520592
            ) < 1e-12
        )
        #expect(
            abs(
                result
                    .signedIsothermalHeatDuty
                - 15255.567263342953
            ) < 1e-9
        )
    }

    @Test(
        "Handles zero humidity and an unchanged state"
    )
    func dryAirBoundary() throws {
        let result = try engine.calculate(
            .init(
                dryAirMassFlowRate: 100,
                dryBulbTemperatureCelsius:
                    20,
                totalPressureKPa: 101.325,
                inletRelativeHumidity: 0,
                outletRelativeHumidity: 0
            )
        )

        #expect(
            result.inletHumidityRatio == 0
        )
        #expect(
            result.outletHumidityRatio == 0
        )
        #expect(
            result.signedWaterTransferRate
            == 0
        )
        #expect(
            result.inletDewPointCelsius
            == nil
        )
        #expect(
            result.outletDewPointCelsius
            == nil
        )
    }

    @Test(
        "Rejects invalid temperature, humidity, pressure and nonfinite values"
    )
    func validation() {
        #expect(
            throws:
                HumidificationPsychrometricsError
                    .temperatureOutsideCorrelationRange
        ) {
            try engine.calculate(
                .init(
                    dryAirMassFlowRate: 100,
                    dryBulbTemperatureCelsius:
                        80,
                    totalPressureKPa:
                        101.325,
                    inletRelativeHumidity:
                        0.3,
                    outletRelativeHumidity:
                        0.6
                )
            )
        }

        #expect(
            throws:
                HumidificationPsychrometricsError
                    .relativeHumidityOutOfRange
        ) {
            try engine.calculate(
                .init(
                    dryAirMassFlowRate: 100,
                    dryBulbTemperatureCelsius:
                        25,
                    totalPressureKPa:
                        101.325,
                    inletRelativeHumidity:
                        1.1,
                    outletRelativeHumidity:
                        0.6
                )
            )
        }

        #expect(
            throws:
                HumidificationPsychrometricsError
                    .pressureAtOrBelowSaturation
        ) {
            try engine.calculate(
                .init(
                    dryAirMassFlowRate: 100,
                    dryBulbTemperatureCelsius:
                        25,
                    totalPressureKPa: 3,
                    inletRelativeHumidity:
                        0.3,
                    outletRelativeHumidity:
                        0.6
                )
            )
        }

        #expect(
            throws:
                HumidificationPsychrometricsError
                    .nonFiniteInput
        ) {
            try engine.calculate(
                .init(
                    dryAirMassFlowRate: .nan,
                    dryBulbTemperatureCelsius:
                        25,
                    totalPressureKPa:
                        101.325,
                    inletRelativeHumidity:
                        0.3,
                    outletRelativeHumidity:
                        0.6
                )
            )
        }
    }
}
