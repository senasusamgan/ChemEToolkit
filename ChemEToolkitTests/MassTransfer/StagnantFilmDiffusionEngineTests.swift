import Testing
@testable import ChemEToolkit

@Suite("Stagnant-Film Diffusion Engine")
struct StagnantFilmDiffusionEngineTests {
    private let engine = StagnantFilmDiffusionEngine()

    @Test("Calculates Stefan diffusion through stagnant B")
    func calculatesFlux() throws {
        let result = try engine.calculate(.init(
            diffusivity: 2e-5,
            totalPressure: 101325,
            temperature: 298.15,
            thickness: 0.01,
            moleFractionAAtSideOne: 0.4,
            moleFractionAAtSideTwo: 0.1
        ))
        #expect(abs(result.fluxA - 0.033145997763750316) < 1.0e-12)
        #expect(result.modelName == "Stefan diffusion through stagnant B")
    }

    @Test("Uses limiting log-mean value at equal compositions")
    func equalCompositions() throws {
        let result = try engine.calculate(.init(
            diffusivity: 1,
            totalPressure: 1,
            temperature: 1,
            thickness: 1,
            moleFractionAAtSideOne: 0.2,
            moleFractionAAtSideTwo: 0.2
        ))
        #expect(result.fluxA == 0)
        #expect(abs(result.logMeanInertFraction - 0.8) < 1e-12)
    }

    @Test("Validates singular, nonpositive, and nonfinite inputs")
    func validation() {
        #expect(throws: StagnantFilmDiffusionError.singularInertFraction) {
            try engine.calculate(.init(
                diffusivity: 1, totalPressure: 1, temperature: 1, thickness: 1,
                moleFractionAAtSideOne: 1, moleFractionAAtSideTwo: 0.2
            ))
        }
        #expect(throws: StagnantFilmDiffusionError.nonPositiveProperty) {
            try engine.calculate(.init(
                diffusivity: 1, totalPressure: 1, temperature: 0, thickness: 1,
                moleFractionAAtSideOne: 0.5, moleFractionAAtSideTwo: 0.2
            ))
        }
        #expect(throws: StagnantFilmDiffusionError.nonFiniteInput) {
            try engine.calculate(.init(
                diffusivity: .infinity, totalPressure: 1, temperature: 1, thickness: 1,
                moleFractionAAtSideOne: 0.5, moleFractionAAtSideTwo: 0.2
            ))
        }
    }
}
