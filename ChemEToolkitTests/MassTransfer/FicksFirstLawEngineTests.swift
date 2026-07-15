import Testing
@testable import ChemEToolkit

@Suite("Fick's First Law Engine")
struct FicksFirstLawEngineTests {
    private let engine = FicksFirstLawEngine()

    @Test("Calculates signed molar flux")
    func calculatesFlux() throws {
        let result = try engine.calculate(.init(
            diffusivity: 1.0e-5,
            concentrationGradient: -20
        ))
        #expect(abs(result.molarFlux - 2.0e-4) < 1.0e-12)
        #expect(result.directionDescription == "Positive coordinate direction")
    }

    @Test("Returns zero flux for zero gradient")
    func zeroGradient() throws {
        let result = try engine.calculate(.init(
            diffusivity: 1.0e-5,
            concentrationGradient: 0
        ))
        #expect(result.molarFlux == 0)
    }

    @Test("Validates diffusivity and finite values")
    func validation() {
        #expect(throws: FicksFirstLawError.nonPositiveDiffusivity) {
            try engine.calculate(.init(diffusivity: 0, concentrationGradient: 2))
        }
        #expect(throws: FicksFirstLawError.nonFiniteInput) {
            try engine.calculate(.init(diffusivity: .infinity, concentrationGradient: 2))
        }
    }
}
