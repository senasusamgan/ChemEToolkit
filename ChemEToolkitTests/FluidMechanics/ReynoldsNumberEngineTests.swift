import Foundation
import Testing
@testable import ChemEToolkit

@Suite("Reynolds Number Engine")
struct ReynoldsNumberEngineTests {
    private let engine = ReynoldsNumberEngine()
    private let tolerance = 1e-10

    @Test("Solves using dynamic viscosity")
    func solvesDynamicViscosityCase() throws {
        let result = try engine.solve(
            input: ReynoldsNumberInput(
                velocity: 2,
                diameter: 0.05,
                viscosity: .dynamic(
                    density: 1_000,
                    dynamicViscosity: 0.001
                )
            )
        )

        #expect(abs(result.reynoldsNumber - 100_000) < tolerance)
        #expect(result.flowRegime == .turbulent)
    }

    @Test("Solves using kinematic viscosity")
    func solvesKinematicViscosityCase() throws {
        let result = try engine.solve(
            input: ReynoldsNumberInput(
                velocity: 0.5,
                diameter: 0.01,
                viscosity: .kinematic(
                    kinematicViscosity: 0.00001
                )
            )
        )

        #expect(abs(result.reynoldsNumber - 500) < tolerance)
        #expect(result.flowRegime == .laminar)
    }

    @Test("Rejects a zero kinematic viscosity")
    func rejectsZeroKinematicViscosity() {
        expectError(.invalidKinematicViscosity) {
            _ = try engine.solve(
                input: ReynoldsNumberInput(
                    velocity: 1,
                    diameter: 0.1,
                    viscosity: .kinematic(
                        kinematicViscosity: 0
                    )
                )
            )
        }
    }

    private func expectError(
        _ expected: ReynoldsNumberError,
        operation: () throws -> Void
    ) {
        do {
            try operation()
            Issue.record("Expected \(expected) to be thrown.")
        } catch let error as ReynoldsNumberError {
            #expect(error == expected)
        } catch {
            Issue.record("Expected ReynoldsNumberError; received \(error).")
        }
    }
}
