import Testing
@testable import ChemEToolkit

@Suite("Inverse Power Method Eigenvalue Engine")
struct InversePowerMethodEigenvalueEngineTests {
    private let engine = InversePowerMethodEigenvalueEngine()

    @Test("Finds eigenvalue nearest shift")
    func nearest() throws {
        let r = try engine.calculate(.init(a11: 4, a12: 1, a21: 1, a22: 2, shift: 1.5, initialX: 1, initialY: 1, tolerance: 1e-10, maximumIterations: 500))
        #expect(abs(r.nearestEigenvalue - 1.58578643763) < 1e-8)
        #expect(r.residualNorm < 1e-8)
    }

    @Test("Shift near dominant root selects dominant eigenvalue")
    func shifted() throws {
        let r = try engine.calculate(.init(a11: 4, a12: 1, a21: 1, a22: 2, shift: 4, initialX: 1, initialY: 1, tolerance: 1e-10, maximumIterations: 500))
        #expect(r.nearestEigenvalue > 4)
    }

    @Test("Rejects singular shift")
    func validation() {
        #expect(throws: InversePowerMethodEigenvalueError.singularShiftedMatrix) {
            try engine.calculate(.init(a11: 2, a12: 0, a21: 0, a22: 3, shift: 2, initialX: 1, initialY: 1, tolerance: 1e-8, maximumIterations: 100))
        }
    }
}
