import Foundation
import Testing
@testable import ChemEToolkit

@Suite("Froude Number Engine")
struct FroudeNumberEngineTests {
    private let engine = FroudeNumberEngine()
    private let tolerance = 1e-12

    @Test("Classifies subcritical flow")
    func solvesSubcriticalFlow() throws {
        let result = try engine.solve(
            input: FroudeNumberInput(
                averageVelocity: 1,
                hydraulicDepth: 1,
                gravity: 4
            )
        )

        #expect(abs(result.gravityWaveCelerity - 2) < tolerance)
        #expect(abs(result.froudeNumber - 0.5) < tolerance)
        #expect(result.flowRegime == .subcritical)
    }

    @Test("Recognizes the critical-flow boundary")
    func recognizesCriticalFlow() throws {
        let result = try engine.solve(
            input: FroudeNumberInput(
                averageVelocity: 2,
                hydraulicDepth: 1,
                gravity: 4
            )
        )

        #expect(abs(result.froudeNumber - 1) < tolerance)
        #expect(result.flowRegime == .critical)
    }

    @Test("Rejects a zero hydraulic depth")
    func rejectsZeroHydraulicDepth() {
        expectError(.invalidHydraulicDepth) {
            _ = try engine.solve(
                input: FroudeNumberInput(
                    averageVelocity: 1,
                    hydraulicDepth: 0
                )
            )
        }
    }

    private func expectError(
        _ expected: FroudeNumberError,
        operation: () throws -> Void
    ) {
        do {
            try operation()
            Issue.record("Expected \(expected) to be thrown.")
        } catch let error as FroudeNumberError {
            #expect(error == expected)
        } catch {
            Issue.record("Expected FroudeNumberError; received \(error).")
        }
    }
}
