import Testing
@testable import ChemEToolkit

@Suite("Shooting Method Boundary Value Engine")
struct ShootingMethodBoundaryValueEngineTests {
    private let engine = ShootingMethodBoundaryValueEngine()

    @Test("Finds sine boundary slope")
    func sineBoundary() throws {
        let r = try engine.calculate(.init(coefficientK: 1, initialX: 0, finalX: 1.5707963267948966, initialY: 0, targetFinalY: 1, initialSlopeGuessOne: 0.5, initialSlopeGuessTwo: 1.5, stepSize: 0.01, tolerance: 1e-10, maximumIterations: 50))
        #expect(abs(r.requiredInitialSlope - 1) < 1e-6)
        #expect(abs(r.boundaryResidual) < 1e-8)
    }

    @Test("Larger target requires larger slope")
    func trend() throws {
        let a = try engine.calculate(.init(coefficientK: 1, initialX: 0, finalX: 1.5707963267948966, initialY: 0, targetFinalY: 0.5, initialSlopeGuessOne: 0.2, initialSlopeGuessTwo: 1, stepSize: 0.01, tolerance: 1e-9, maximumIterations: 50))
        let b = try engine.calculate(.init(coefficientK: 1, initialX: 0, finalX: 1.5707963267948966, initialY: 0, targetFinalY: 1, initialSlopeGuessOne: 0.5, initialSlopeGuessTwo: 1.5, stepSize: 0.01, tolerance: 1e-9, maximumIterations: 50))
        #expect(b.requiredInitialSlope > a.requiredInitialSlope)
    }

    @Test("Rejects reversed interval")
    func validation() {
        #expect(throws: ShootingMethodBoundaryValueError.invalidInterval) {
            try engine.calculate(.init(coefficientK: 1, initialX: 2, finalX: 1, initialY: 0, targetFinalY: 1, initialSlopeGuessOne: 0.5, initialSlopeGuessTwo: 1.5, stepSize: 0.01, tolerance: 1e-8, maximumIterations: 50))
        }
    }
}
