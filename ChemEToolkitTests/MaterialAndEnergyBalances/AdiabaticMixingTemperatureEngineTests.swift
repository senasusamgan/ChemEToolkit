import Testing
@testable import ChemEToolkit

@Suite("Adiabatic Mixing Temperature Engine")
struct AdiabaticMixingTemperatureEngineTests {
    private let engine =
        AdiabaticMixingTemperatureEngine()

    @Test("Calculates mixed temperature")
    func mixing() throws {
        let result = try engine.calculate(
            .init(
                stream1MassFlow: 2,
                stream1HeatCapacity: 4,
                stream1Temperature: 80,
                stream2MassFlow: 3,
                stream2HeatCapacity: 2,
                stream2Temperature: 20
            )
        )

        #expect(result.stream1HeatCapacityRate == 8)
        #expect(result.stream2HeatCapacityRate == 6)

        #expect(
            abs(
                result.mixedTemperature
                - 760.0 / 14.0
            ) < 1e-12
        )

        #expect(result.totalMassFlow == 5)
    }

    @Test("Zero-flow second stream preserves first temperature")
    func oneStream() throws {
        let result = try engine.calculate(
            .init(
                stream1MassFlow: 2,
                stream1HeatCapacity: 4,
                stream1Temperature: 80,
                stream2MassFlow: 0,
                stream2HeatCapacity: 2,
                stream2Temperature: 20
            )
        )

        #expect(result.mixedTemperature == 80)
    }

    @Test("Rejects zero total capacity rate")
    func validation() {
        #expect(
            throws:
                AdiabaticMixingTemperatureError
                    .zeroTotalCapacityRate
        ) {
            try engine.calculate(
                .init(
                    stream1MassFlow: 0,
                    stream1HeatCapacity: 4,
                    stream1Temperature: 80,
                    stream2MassFlow: 0,
                    stream2HeatCapacity: 2,
                    stream2Temperature: 20
                )
            )
        }
    }
}
