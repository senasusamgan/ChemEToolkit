import Testing
@testable import ChemEToolkit

@Suite("Richardson Error Estimate Engine")
struct RichardsonErrorEstimateEngineTests {
    private let engine = RichardsonErrorEstimateEngine()

    @Test("Calculates second-order extrapolation")
    func extrapolation() throws {
        let r = try engine.calculate(.init(coarseResult: 1.2, fineResult: 1.05, refinementRatio: 2, methodOrder: 2))
        #expect(abs(r.extrapolatedResult - 1) < 1e-12)
        #expect(abs(r.estimatedFineGridError + 0.05) < 1e-12)
    }

    @Test("Closer grids reduce correction")
    func trend() throws {
        let a = try engine.calculate(.init(coarseResult: 1.2, fineResult: 1.05, refinementRatio: 2, methodOrder: 2))
        let b = try engine.calculate(.init(coarseResult: 1.08, fineResult: 1.02, refinementRatio: 2, methodOrder: 2))
        #expect(abs(b.correctionFactor) < abs(a.correctionFactor))
    }

    @Test("Rejects refinement ratio of one")
    func validation() {
        #expect(throws: RichardsonErrorEstimateError.invalidRefinementRatio) {
            try engine.calculate(.init(coarseResult: 1.2, fineResult: 1.05, refinementRatio: 1, methodOrder: 2))
        }
    }
}
