import Foundation
import Testing
@testable import ChemEToolkit

@Suite("Critical Depth Engine")
struct CriticalDepthEngineTests {
    private let engine = CriticalDepthEngine()
    private let tolerance = 1e-10

    @Test("Solves a rectangular-channel reference case")
    func solvesReferenceCase() throws {
        let result = try engine.solve(
            input: CriticalDepthInput(
                volumetricFlowRate: 6,
                channelWidth: 3,
                currentFlowDepth: 1,
                gravity: 10
            )
        )
        let expectedDepth = pow(0.4, 1.0 / 3.0)

        #expect(abs(result.criticalDepth - expectedDepth) < tolerance)
        #expect(abs(result.minimumSpecificEnergy - 1.5 * expectedDepth) < tolerance)
        #expect(abs(result.currentVelocity - 2) < tolerance)
        #expect(result.flowRegime == .subcritical)
    }

    @Test("Classifies a shallow fast flow as supercritical")
    func classifiesSupercriticalFlow() throws {
        let result = try engine.solve(
            input: CriticalDepthInput(
                volumetricFlowRate: 1,
                channelWidth: 1,
                currentFlowDepth: 0.2,
                gravity: 10
            )
        )

        #expect(abs(result.currentVelocity - 5) < tolerance)
        #expect(result.currentFroudeNumber > 1)
        #expect(result.flowRegime == .supercritical)
    }

    @Test("Rejects a zero channel width")
    func rejectsZeroChannelWidth() {
        expectError(.invalidChannelWidth) {
            _ = try engine.solve(
                input: CriticalDepthInput(
                    volumetricFlowRate: 1,
                    channelWidth: 0,
                    currentFlowDepth: 1
                )
            )
        }
    }

    private func expectError(
        _ expected: CriticalDepthError,
        operation: () throws -> Void
    ) {
        do {
            try operation()
            Issue.record("Expected \(expected) to be thrown.")
        } catch let error as CriticalDepthError {
            #expect(error == expected)
        } catch {
            Issue.record("Expected CriticalDepthError; received \(error).")
        }
    }
}
