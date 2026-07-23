import Foundation
import Testing
@testable import ChemEToolkit

@Suite("Minor Loss Engine")
struct MinorLossEngineTests {
    private let engine = MinorLossEngine()
    private let tolerance = 1e-10

    @Test("Combines fitting coefficients into head loss and pressure drop")
    func solvesReferenceCase() throws {
        let result = try engine.solve(
            input: MinorLossInput(
                density: 1_000,
                averageVelocity: 2,
                lossCoefficients: [0.5, 1, 1.5],
                gravity: 10
            )
        )

        #expect(abs(result.totalLossCoefficient - 3) < tolerance)
        #expect(abs(result.velocityHead - 0.2) < tolerance)
        #expect(abs(result.headLoss - 0.6) < tolerance)
        #expect(abs(result.pressureDrop - 6_000) < tolerance)
        #expect(result.fittingCount == 3)
    }

    @Test("Returns zero loss at zero velocity")
    func handlesZeroVelocity() throws {
        let result = try engine.solve(
            input: MinorLossInput(
                density: 998,
                averageVelocity: 0,
                lossCoefficients: [1.2]
            )
        )

        #expect(result.velocityHead == 0)
        #expect(result.headLoss == 0)
        #expect(result.pressureDrop == 0)
    }

    @Test("Rejects an empty coefficient list")
    func rejectsMissingCoefficients() {
        expectError(.missingLossCoefficients) {
            _ = try engine.solve(
                input: MinorLossInput(
                    density: 1_000,
                    averageVelocity: 2,
                    lossCoefficients: []
                )
            )
        }
    }

    private func expectError(
        _ expected: MinorLossError,
        operation: () throws -> Void
    ) {
        do {
            try operation()
            Issue.record("Expected \(expected) to be thrown.")
        } catch let error as MinorLossError {
            #expect(error == expected)
        } catch {
            Issue.record("Expected MinorLossError; received \(error).")
        }
    }
}
