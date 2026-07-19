import Testing
@testable import ChemEToolkit

@Suite("Golden Section Optimization Engine")
struct GoldenSectionOptimizationEngineTests {
    private let engine = GoldenSectionOptimizationEngine()

    @Test("Finds quadratic minimum")
    func minimum() throws {
        let r = try engine.calculate(.init(quadraticA: 2, quadraticB: -8, quadraticC: 10, lowerBound: 0, upperBound: 10, tolerance: 1e-10, maximumIterations: 500))
        #expect(abs(r.minimizingX - 2) < 1e-7)
        #expect(abs(r.minimumValue - 2) < 1e-7)
    }

    @Test("Shifted quadratic changes optimum")
    func trend() throws {
        let a = try engine.calculate(.init(quadraticA: 1, quadraticB: -2, quadraticC: 0, lowerBound: -5, upperBound: 5, tolerance: 1e-9, maximumIterations: 500))
        let b = try engine.calculate(.init(quadraticA: 1, quadraticB: -6, quadraticC: 0, lowerBound: -5, upperBound: 5, tolerance: 1e-9, maximumIterations: 500))
        #expect(b.minimizingX > a.minimizingX)
    }

    @Test("Rejects concave quadratic")
    func validation() {
        #expect(throws: GoldenSectionOptimizationError.nonConvexQuadratic) {
            try engine.calculate(.init(quadraticA: -1, quadraticB: 0, quadraticC: 0, lowerBound: -5, upperBound: 5, tolerance: 1e-8, maximumIterations: 100))
        }
    }
}
