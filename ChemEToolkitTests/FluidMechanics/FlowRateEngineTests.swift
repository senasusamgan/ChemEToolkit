import Foundation
import Testing
@testable import ChemEToolkit

@Suite("Flow Rate Engine")
struct FlowRateEngineTests {
    private let engine = FlowRateEngine()
    private let tolerance = 1e-10

    @Test("Calculates area, volumetric flow, and mass flow")
    func solvesReferenceCase() throws {
        let result = try engine.solve(
            input: FlowRateInput(
                diameter: 2,
                averageVelocity: 3,
                density: 1_000
            )
        )

        #expect(abs(result.crossSectionalArea - Double.pi) < tolerance)
        #expect(abs(result.volumetricFlowRate - 3 * Double.pi) < tolerance)
        #expect(abs(result.massFlowRate - 3_000 * Double.pi) < tolerance)
    }

    @Test("Returns zero flow at zero average velocity")
    func handlesZeroVelocity() throws {
        let result = try engine.solve(
            input: FlowRateInput(
                diameter: 0.1,
                averageVelocity: 0,
                density: 998
            )
        )

        #expect(result.volumetricFlowRate == 0)
        #expect(result.massFlowRate == 0)
        #expect(result.litresPerSecond == 0)
    }

    @Test("Rejects a zero diameter")
    func rejectsZeroDiameter() {
        expectError(.invalidDiameter) {
            _ = try engine.solve(
                input: FlowRateInput(
                    diameter: 0,
                    averageVelocity: 1,
                    density: 1_000
                )
            )
        }
    }

    private func expectError(
        _ expected: FlowRateError,
        operation: () throws -> Void
    ) {
        do {
            try operation()
            Issue.record("Expected \(expected) to be thrown.")
        } catch let error as FlowRateError {
            #expect(error == expected)
        } catch {
            Issue.record("Expected FlowRateError; received \(error).")
        }
    }
}
