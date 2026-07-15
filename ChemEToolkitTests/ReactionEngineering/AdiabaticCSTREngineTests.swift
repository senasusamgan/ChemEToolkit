import Testing
@testable import ChemEToolkit

@Suite("Adiabatic CSTR Engine")
struct AdiabaticCSTREngineTests {
    private let engine =
        AdiabaticCSTREngine()

    @Test("Sizes an exothermic adiabatic CSTR")
    func sizesCSTR() throws {
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
                - 4.7395460745733597
            ) < 1e-9
        )
        #expect(
            abs(
                result.requiredReactorVolume
                - 0.0473954607457336
            ) < 1e-12
        )
        #expect(
            abs(
                result.outletTemperature
                - 430
            ) < 1e-12
        )
        #expect(
            abs(
                result.outletRateConstant
                - 0.8439626785060993
            ) < 1e-12
        )
        #expect(
            result.requiredReactorVolume
            < result.isothermalReactorVolume
        )
    }

    @Test("Zero heat release matches isothermal sizing")
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
            ) < 1e-12
        )
        #expect(
            abs(
                result.isothermalToAdiabaticVolumeRatio
                - 1
            ) < 1e-12
        )
    }

    @Test("Rejects invalid inputs")
    func validation() {
        #expect(
            throws:
                AdiabaticCSTRError
                    .conversionOutOfRange
        ) {
            try engine.calculate(
                .init(
                    inletConcentrationA: 100,
                    inletVolumetricFlowRate: 0.01,
                    preExponentialFactor: 1_000_000,
                    activationEnergy: 50_000,
                    inletTemperature: 350,
                    adiabaticTemperatureRise: 100,
                    targetConversion: 0
                )
            )
        }

        #expect(
            throws:
                AdiabaticCSTRError
                    .negativeActivationEnergy
        ) {
            try engine.calculate(
                .init(
                    inletConcentrationA: 100,
                    inletVolumetricFlowRate: 0.01,
                    preExponentialFactor: 1_000_000,
                    activationEnergy: -1,
                    inletTemperature: 350,
                    adiabaticTemperatureRise: 100,
                    targetConversion: 0.8
                )
            )
        }

        #expect(
            throws:
                AdiabaticCSTRError
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
