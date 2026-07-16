import Testing
@testable import ChemEToolkit

@Suite("Non-Isothermal CSTR Steady States Engine")
struct NonIsothermalCSTRSteadyStatesEngineTests {
    private let engine =
        NonIsothermalCSTRSteadyStatesEngine()

    @Test("Finds one physical steady state")
    func oneSteadyState() throws {
        let result = try engine.calculate(
            .init(
                inletConcentrationA: 100,
                spaceTime: 5,
                preExponentialFactor: 1_000_000,
                activationEnergy: 50_000,
                inletTemperature: 330,
                adiabaticTemperatureRise: 100,
                coolantTemperature: 300,
                heatRemovalNumber: 3
            )
        )

        #expect(result.steadyStateCount == 1)
        #expect(abs(result.lowestTemperatureState.temperature - 307.9052464797162) < 1e-7)
        #expect(abs(result.lowestTemperatureState.conversion - 0.016209859188692163) < 1e-9)
        #expect(abs(result.lowestTemperatureState.residual) < 1e-9)
    }

    @Test("Detects classical three-state multiplicity")
    func threeSteadyStates() throws {
        let result = try engine.calculate(
            .init(
                inletConcentrationA: 100,
                spaceTime: 1,
                preExponentialFactor: 1_000_000,
                activationEnergy: 50_000,
                inletTemperature: 330,
                adiabaticTemperatureRise: 200,
                coolantTemperature: 300,
                heatRemovalNumber: 0
            )
        )

        #expect(result.steadyStateCount == 3)
        #expect(result.middleTemperatureState != nil)
        #expect(abs(result.lowestTemperatureState.temperature - 332.8011197227985) < 1e-7)
        #expect(abs(result.middleTemperatureState!.temperature - 445.0523177741095) < 1e-7)
        #expect(abs(result.highestTemperatureState.temperature - 503.13336962871244) < 1e-7)
        #expect(result.lowestTemperatureState.conversion < result.highestTemperatureState.conversion)
    }

    @Test("Rejects invalid multiplicity inputs")
    func validation() {
        #expect(throws: NonIsothermalCSTRSteadyStatesError.nonPositiveAdiabaticRise) {
            try engine.calculate(
                .init(
                    inletConcentrationA: 100,
                    spaceTime: 1,
                    preExponentialFactor: 1_000_000,
                    activationEnergy: 50_000,
                    inletTemperature: 330,
                    adiabaticTemperatureRise: 0,
                    coolantTemperature: 300,
                    heatRemovalNumber: 0
                )
            )
        }

        #expect(throws: NonIsothermalCSTRSteadyStatesError.negativeHeatRemovalNumber) {
            try engine.calculate(
                .init(
                    inletConcentrationA: 100,
                    spaceTime: 1,
                    preExponentialFactor: 1_000_000,
                    activationEnergy: 50_000,
                    inletTemperature: 330,
                    adiabaticTemperatureRise: 200,
                    coolantTemperature: 300,
                    heatRemovalNumber: -1
                )
            )
        }

        #expect(throws: NonIsothermalCSTRSteadyStatesError.nonFiniteInput) {
            try engine.calculate(
                .init(
                    inletConcentrationA: .nan,
                    spaceTime: 1,
                    preExponentialFactor: 1_000_000,
                    activationEnergy: 50_000,
                    inletTemperature: 330,
                    adiabaticTemperatureRise: 200,
                    coolantTemperature: 300,
                    heatRemovalNumber: 0
                )
            )
        }
    }
}
