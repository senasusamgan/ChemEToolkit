import Testing
@testable import ChemEToolkit

@Suite("Adiabatic PFR Engine")
struct AdiabaticPFREngineTests {
    private let engine =
        AdiabaticPFREngine()

    @Test("Sizes an exothermic adiabatic PFR")
    func sizesPFR() throws {
        let result = try engine.calculate(
            .init(
                inletConcentrationA: 100,
                inletVolumetricFlowRate: 0.01,
                preExponentialFactor: 1_000_000,
                activationEnergy: 50_000,
                inletTemperature: 350,
                adiabaticTemperatureRise: 100,
                targetConversion: 0.8
            )
        )

        #expect(
            abs(
                result.requiredSpaceTime
                - 8.7784770086820494
            ) < 1e-9
        )
        #expect(
            abs(
                result.requiredReactorVolume
                - 0.087784770086820493
            ) < 1e-12
        )
        #expect(
            abs(
                result.outletTemperature
                - 430
            ) < 1e-12
        )
        #expect(
            result.requiredReactorVolume
            < result.isothermalReactorVolume
        )
    }

    @Test("Zero heat release matches isothermal PFR")
    func zeroTemperatureRise() throws {
        let result = try engine.calculate(
            .init(
                inletConcentrationA: 100,
                inletVolumetricFlowRate: 0.01,
                preExponentialFactor: 1_000_000,
                activationEnergy: 50_000,
                inletTemperature: 350,
                adiabaticTemperatureRise: 0,
                targetConversion: 0.8
            )
        )

        #expect(
            abs(
                result.requiredReactorVolume
                - result.isothermalReactorVolume
            ) < 1e-11
        )
        #expect(result.outletTemperature == 350)
    }

    @Test("Rejects invalid inputs")
    func validation() {
        #expect(
            throws:
                AdiabaticPFRError
                    .nonPositiveFeedOrFactor
        ) {
            try engine.calculate(
                .init(
                    inletConcentrationA: 100,
                    inletVolumetricFlowRate: 0,
                    preExponentialFactor: 1_000_000,
                    activationEnergy: 50_000,
                    inletTemperature: 350,
                    adiabaticTemperatureRise: 100,
                    targetConversion: 0.8
                )
            )
        }

        #expect(
            throws:
                AdiabaticPFRError
                    .nonPositiveTemperature
        ) {
            try engine.calculate(
                .init(
                    inletConcentrationA: 100,
                    inletVolumetricFlowRate: 0.01,
                    preExponentialFactor: 1_000_000,
                    activationEnergy: 50_000,
                    inletTemperature: 350,
                    adiabaticTemperatureRise: -500,
                    targetConversion: 0.8
                )
            )
        }

        #expect(
            throws:
                AdiabaticPFRError
                    .nonFiniteInput
        ) {
            try engine.calculate(
                .init(
                    inletConcentrationA: .nan,
                    inletVolumetricFlowRate: 0.01,
                    preExponentialFactor: 1_000_000,
                    activationEnergy: 50_000,
                    inletTemperature: 350,
                    adiabaticTemperatureRise: 100,
                    targetConversion: 0.8
                )
            )
        }
    }
}
