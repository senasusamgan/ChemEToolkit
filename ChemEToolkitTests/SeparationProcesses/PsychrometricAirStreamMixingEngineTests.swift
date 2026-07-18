import Testing
@testable import ChemEToolkit

@Suite("Psychrometric Air Stream Mixing Engine")
struct PsychrometricAirStreamMixingEngineTests {
    private let engine =
        PsychrometricAirStreamMixingEngine()

    @Test("Closes dry-air and water balances")
    func mixing() throws {
        let result =
            try engine.calculate(
                .init(
                    dryAirFlow1: 600,
                    temperature1C: 35,
                    humidityRatio1: 0.010,
                    dryAirFlow2: 400,
                    temperature2C: 15,
                    humidityRatio2: 0.006
                )
            )

        #expect(
            result.mixedDryAirFlow
            == 1000
        )

        #expect(
            abs(
                result.mixedHumidityRatio
                - 0.0084
            ) < 1e-12
        )

        #expect(
            result.mixedTemperatureC
            > 15
        )

        #expect(
            result.mixedTemperatureC
            < 35
        )
    }

    @Test("Equal streams preserve their state")
    func equalStreams() throws {
        let result =
            try engine.calculate(
                .init(
                    dryAirFlow1: 500,
                    temperature1C: 25,
                    humidityRatio1: 0.01,
                    dryAirFlow2: 500,
                    temperature2C: 25,
                    humidityRatio2: 0.01
                )
            )

        #expect(
            abs(
                result.mixedTemperatureC
                - 25
            ) < 1e-12
        )

        #expect(
            abs(
                result.mixedHumidityRatio
                - 0.01
            ) < 1e-12
        )
    }

    @Test("Rejects zero dry-air flow")
    func validation() {
        #expect(
            throws:
                PsychrometricAirStreamMixingError
                    .nonPositiveFlow
        ) {
            try engine.calculate(
                .init(
                    dryAirFlow1: 0,
                    temperature1C: 35,
                    humidityRatio1: 0.01,
                    dryAirFlow2: 400,
                    temperature2C: 15,
                    humidityRatio2: 0.006
                )
            )
        }
    }
}
