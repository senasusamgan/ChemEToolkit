import Testing
@testable import ChemEToolkit

@Suite("Power Method Eigenvalue Engine")
struct PowerMethodEigenvalueEngineTests {
    private let engine = PowerMethodEigenvalueEngine()

    @Test("Finds dominant eigenvalue")
    func dominant() throws {
        let r = try engine.calculate(.init(a11: 4, a12: 1, a21: 1, a22: 2, initialX: 1, initialY: 1, tolerance: 1e-10, maximumIterations: 500))
        #expect(abs(r.dominantEigenvalue - 4.41421356237) < 1e-8)
        #expect(r.residualNorm < 1e-8)
    }

    @Test("Scaled initial vector gives same eigenvalue")
    func scaling() throws {
        let a = try engine.calculate(.init(a11: 4, a12: 1, a21: 1, a22: 2, initialX: 1, initialY: 1, tolerance: 1e-10, maximumIterations: 500))
        let b = try engine.calculate(.init(a11: 4, a12: 1, a21: 1, a22: 2, initialX: 10, initialY: 10, tolerance: 1e-10, maximumIterations: 500))
        #expect(abs(a.dominantEigenvalue - b.dominantEigenvalue) < 1e-8)
    }

    @Test("Rejects zero vector")
    func validation() {
        #expect(throws: PowerMethodEigenvalueError.zeroInitialVector) {
            try engine.calculate(.init(a11: 4, a12: 1, a21: 1, a22: 2, initialX: 0, initialY: 0, tolerance: 1e-8, maximumIterations: 100))
        }
    }
}
