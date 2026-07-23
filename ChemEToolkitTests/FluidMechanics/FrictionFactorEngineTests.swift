import Foundation
import Testing
@testable import ChemEToolkit

@Suite("Friction Factor Engine")
struct FrictionFactorEngineTests {
    private let engine = FrictionFactorEngine()
    private let tolerance = 1e-12

    @Test("Uses the exact laminar Darcy relation")
    func solvesLaminarFlow() throws {
        let result = try engine.solve(
            input: FrictionFactorInput(
                reynoldsNumber: 1_000,
                pipeDiameter: 0.1,
                absoluteRoughness: 0
            )
        )

        #expect(abs(result.darcyFrictionFactor - 0.064) < tolerance)
        #expect(abs(result.fanningFrictionFactor - 0.016) < tolerance)
        #expect(result.flowRegime == .laminar)
        #expect(result.iterationCount == 0)
        #expect(!result.usedIterativeEquation)
    }

    @Test("Converges for a turbulent rough-pipe case")
    func solvesTurbulentFlow() throws {
        let result = try engine.solve(
            input: FrictionFactorInput(
                reynoldsNumber: 100_000,
                pipeDiameter: 0.1,
                absoluteRoughness: 0.0001
            )
        )

        #expect(result.flowRegime == .turbulent)
        #expect(result.darcyFrictionFactor > 0.022)
        #expect(result.darcyFrictionFactor < 0.0223)
        #expect(abs(result.fanningFrictionFactor * 4 - result.darcyFrictionFactor) < tolerance)
        #expect(result.usedIterativeEquation)
    }

    @Test("Rejects transitional flow")
    func rejectsTransitionalFlow() {
        expectError(.transitionalFlowUnsupported) {
            _ = try engine.solve(
                input: FrictionFactorInput(
                    reynoldsNumber: 3_000,
                    pipeDiameter: 0.1,
                    absoluteRoughness: 0.0001
                )
            )
        }
    }

    private func expectError(
        _ expected: FrictionFactorError,
        operation: () throws -> Void
    ) {
        do {
            try operation()
            Issue.record("Expected \(expected) to be thrown.")
        } catch let error as FrictionFactorError {
            #expect(error == expected)
        } catch {
            Issue.record("Expected FrictionFactorError; received \(error).")
        }
    }
}
