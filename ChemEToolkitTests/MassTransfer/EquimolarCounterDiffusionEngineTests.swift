import Testing
@testable import ChemEToolkit

@Suite("Equimolar Counter-Diffusion Engine")
struct EquimolarCounterDiffusionEngineTests {
    private let engine = EquimolarCounterDiffusionEngine()

    @Test("Calculates equal and opposite component fluxes")
    func calculatesFluxes() throws {
        let result = try engine.calculate(.init(
            diffusivity: 2e-5,
            totalPressure: 101325,
            temperature: 298.15,
            thickness: 0.01,
            moleFractionAAtSideOne: 0.8,
            moleFractionAAtSideTwo: 0.2
        ))
        #expect(abs(result.fluxA - 0.049056) < 0.00001)
        #expect(abs(result.fluxA + result.fluxB) < 1e-12)
        #expect(result.totalMolarFlux == 0)
    }

    @Test("Returns zero flux at equal mole fractions")
    func equalMoleFractions() throws {
        let result = try engine.calculate(.init(
            diffusivity: 1e-5,
            totalPressure: 100000,
            temperature: 300,
            thickness: 0.01,
            moleFractionAAtSideOne: 0.4,
            moleFractionAAtSideTwo: 0.4
        ))
        #expect(result.fluxA == 0)
        #expect(result.fluxB == 0)
    }

    @Test("Validates properties, mole fractions, and finite values")
    func validation() {
        #expect(throws: EquimolarCounterDiffusionError.nonPositiveProperty) {
            try engine.calculate(.init(
                diffusivity: 0, totalPressure: 1, temperature: 1, thickness: 1,
                moleFractionAAtSideOne: 0.5, moleFractionAAtSideTwo: 0.2
            ))
        }
        #expect(throws: EquimolarCounterDiffusionError.invalidMoleFraction) {
            try engine.calculate(.init(
                diffusivity: 1, totalPressure: 1, temperature: 1, thickness: 1,
                moleFractionAAtSideOne: 1.1, moleFractionAAtSideTwo: 0.2
            ))
        }
        #expect(throws: EquimolarCounterDiffusionError.nonFiniteInput) {
            try engine.calculate(.init(
                diffusivity: 1, totalPressure: .nan, temperature: 1, thickness: 1,
                moleFractionAAtSideOne: 0.5, moleFractionAAtSideTwo: 0.2
            ))
        }
    }
}
