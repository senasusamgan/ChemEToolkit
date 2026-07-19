import Foundation
import Testing
@testable import ChemEToolkit

@Suite("Adaptive Runge Kutta 45 Engine")
struct AdaptiveRungeKutta45EngineTests {
    private let engine = AdaptiveRungeKutta45Engine()

    @Test("Integrates a linear ODE")
    func integration() throws {
        let result =
            try engine.calculate(
                .init(
                    coefficientA: 1,
                    coefficientB: -1,
                    initialX: 0,
                    finalX: 2,
                    initialY: 1,
                    initialStep: 0.2,
                    tolerance: 1e-7,
                    maximumSteps: 10000
                )
            )

        let expected =
            1.0
            + 2.0
                * Foundation.exp(-2.0)

        #expect(
            abs(
                result.finalY
                - expected
            ) < 1e-5
        )

        #expect(
            result.acceptedSteps
            > 0
        )
    }

    @Test("Tighter tolerance does not reduce accepted steps")
    func trend() throws {
        let a = try engine.calculate(.init(coefficientA: 1, coefficientB: -1, initialX: 0, finalX: 2, initialY: 1, initialStep: 0.2, tolerance: 1e-4, maximumSteps: 10000))
        let b = try engine.calculate(.init(coefficientA: 1, coefficientB: -1, initialX: 0, finalX: 2, initialY: 1, initialStep: 0.2, tolerance: 1e-8, maximumSteps: 10000))
        #expect(b.acceptedSteps >= a.acceptedSteps)
    }

    @Test("Rejects reversed interval")
    func validation() {
        #expect(throws: AdaptiveRungeKutta45Error.invalidInterval) {
            try engine.calculate(.init(coefficientA: 1, coefficientB: -1, initialX: 2, finalX: 0, initialY: 1, initialStep: 0.2, tolerance: 1e-6, maximumSteps: 100))
        }
    }
}
