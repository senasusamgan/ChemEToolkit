import Testing
@testable import ChemEToolkit

@Suite("Gauss Newton Nonlinear Regression Engine")
struct GaussNewtonNonlinearRegressionEngineTests {
    private let engine = GaussNewtonNonlinearRegressionEngine()

    @Test("Recovers exponential parameters")
    func fit() throws {
        let r = try engine.calculate(.init(x1: 0, y1: 2, x2: 1, y2: 3.2974425414, x3: 2, y3: 5.4365636569, initialA: 1.5, initialB: 0.4, tolerance: 1e-12, maximumIterations: 100))
        #expect(abs(r.parameterA - 2) < 1e-8)
        #expect(abs(r.parameterB - 0.5) < 1e-8)
    }

    @Test("Exact data yields tiny error")
    func exact() throws {
        let r = try engine.calculate(.init(x1: 0, y1: 2, x2: 1, y2: 3.2974425414, x3: 2, y3: 5.4365636569, initialA: 2.2, initialB: 0.45, tolerance: 1e-12, maximumIterations: 100))
        #expect(r.rootMeanSquaredError < 1e-8)
    }

    @Test("Rejects nonpositive y")
    func validation() {
        #expect(throws: GaussNewtonNonlinearRegressionError.nonPositiveResponse) {
            try engine.calculate(.init(x1: 0, y1: 0, x2: 1, y2: 2, x3: 2, y3: 3, initialA: 1, initialB: 0.1, tolerance: 1e-8, maximumIterations: 100))
        }
    }
}
