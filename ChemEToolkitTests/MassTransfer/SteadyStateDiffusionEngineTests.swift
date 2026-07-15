import Testing
@testable import ChemEToolkit

@Suite("Steady-State Diffusion Engine")
struct SteadyStateDiffusionEngineTests {
    private let engine = SteadyStateDiffusionEngine()

    @Test("Calculates planar diffusion flux and rate")
    func calculatesDiffusion() throws {
        let result = try engine.calculate(.init(
            diffusivity: 1e-5,
            area: 0.5,
            thickness: 0.01,
            concentrationAtSideOne: 2,
            concentrationAtSideTwo: 0.5
        ))
        #expect(abs(result.molarFlux - 0.0015) < 1e-12)
        #expect(abs(result.molarRate - 0.00075) < 1e-12)
        #expect(result.midpointConcentration == 1.25)
    }

    @Test("Returns zero transport at equal concentrations")
    func equalConcentrations() throws {
        let result = try engine.calculate(.init(
            diffusivity: 1,
            area: 2,
            thickness: 3,
            concentrationAtSideOne: 4,
            concentrationAtSideTwo: 4
        ))
        #expect(result.molarFlux == 0)
        #expect(result.molarRate == 0)
    }

    @Test("Validates geometry, concentration, and finite input")
    func validation() {
        #expect(throws: SteadyStateDiffusionError.nonPositiveGeometryOrDiffusivity) {
            try engine.calculate(.init(
                diffusivity: 1, area: 0, thickness: 1,
                concentrationAtSideOne: 1, concentrationAtSideTwo: 0
            ))
        }
        #expect(throws: SteadyStateDiffusionError.negativeConcentration) {
            try engine.calculate(.init(
                diffusivity: 1, area: 1, thickness: 1,
                concentrationAtSideOne: -1, concentrationAtSideTwo: 0
            ))
        }
        #expect(throws: SteadyStateDiffusionError.nonFiniteInput) {
            try engine.calculate(.init(
                diffusivity: 1, area: 1, thickness: .infinity,
                concentrationAtSideOne: 1, concentrationAtSideTwo: 0
            ))
        }
    }
}
