import Testing
@testable import ChemEToolkit

@Suite("Adiabatic Batch Reactor Engine")
struct AdiabaticBatchReactorEngineTests {
    private let engine =
        AdiabaticBatchReactorEngine()

    @Test("Calculates exothermic adiabatic batch time")
    func exothermicBatch() throws {
        let result = try engine.calculate(
            .init(
                initialConcentrationA: 100,
                preExponentialFactor: 1_000_000,
                activationEnergy: 50_000,
                initialTemperature: 350,
                adiabaticTemperatureRise: 100,
                targetConversion: 0.8
            )
        )

        #expect(
            abs(
                result.timeToTargetConversion
                - 8.7784770086820494
            ) < 1e-9
        )
        #expect(
            abs(
                result.finalTemperature
                - 430
            ) < 1e-12
        )
        #expect(
            abs(
                result.initialRateConstant
                - 0.034518687043909584
            ) < 1e-12
        )
        #expect(
            abs(
                result.finalRateConstant
                - 0.8439626785060993
            ) < 1e-12
        )
        #expect(
            result.timeToTargetConversion
            < result.isothermalTimeAtInitialTemperature
        )
    }

    @Test("Zero heat release matches isothermal first-order time")
    func zeroTemperatureRise() throws {
        let result = try engine.calculate(
            .init(
                initialConcentrationA: 100,
                preExponentialFactor: 1_000_000,
                activationEnergy: 50_000,
                initialTemperature: 350,
                adiabaticTemperatureRise: 0,
                targetConversion: 0.8
            )
        )

        #expect(
            abs(
                result.timeToTargetConversion
                - result.isothermalTimeAtInitialTemperature
            ) < 1e-9
        )
        #expect(result.finalTemperature == 350)
    }

    @Test("Rejects invalid temperature and conversion")
    func validation() {
        #expect(
            throws:
                AdiabaticBatchReactorError
                    .conversionOutOfRange
        ) {
            try engine.calculate(
                .init(
                    initialConcentrationA: 100,
                    preExponentialFactor: 1_000_000,
                    activationEnergy: 50_000,
                    initialTemperature: 350,
                    adiabaticTemperatureRise: 100,
                    targetConversion: 1
                )
            )
        }

        #expect(
            throws:
                AdiabaticBatchReactorError
                    .nonPositiveTemperature
        ) {
            try engine.calculate(
                .init(
                    initialConcentrationA: 100,
                    preExponentialFactor: 1_000_000,
                    activationEnergy: 50_000,
                    initialTemperature: 350,
                    adiabaticTemperatureRise: -500,
                    targetConversion: 0.8
                )
            )
        }

        #expect(
            throws:
                AdiabaticBatchReactorError
                    .nonFiniteInput
        ) {
            try engine.calculate(
                .init(
                    initialConcentrationA: .nan,
                    preExponentialFactor: 1_000_000,
                    activationEnergy: 50_000,
                    initialTemperature: 350,
                    adiabaticTemperatureRise: 100,
                    targetConversion: 0.8
                )
            )
        }
    }
}
