import Foundation
import Testing
@testable import ChemEToolkit

@Suite("Pressure Drop Engine")
struct PressureDropEngineTests {
    private let engine = PressureDropEngine()
    private let tolerance = 1e-10

    @Test("Solves a laminar Darcy-Weisbach reference case")
    func solvesLaminarReferenceCase() throws {
        let result = try engine.solve(
            input: PressureDropInput(
                density: 1_000,
                averageVelocity: 0.01,
                pipeDiameter: 0.1,
                pipeLength: 10,
                dynamicViscosity: 0.001,
                absoluteRoughness: 0,
                gravity: 10
            )
        )

        #expect(abs(result.reynoldsNumber - 1_000) < tolerance)
        #expect(result.flowRegime == .laminar)
        #expect(abs(result.darcyFrictionFactor - 0.064) < tolerance)
        #expect(abs(result.headLoss - 0.000032) < tolerance)
        #expect(abs(result.pressureDrop - 0.32) < tolerance)
    }

    @Test("Solves a turbulent rough-pipe case")
    func solvesTurbulentCase() throws {
        let result = try engine.solve(
            input: PressureDropInput(
                density: 1_000,
                averageVelocity: 1,
                pipeDiameter: 0.1,
                pipeLength: 10,
                dynamicViscosity: 0.001,
                absoluteRoughness: 0.0001,
                gravity: 10
            )
        )

        #expect(abs(result.reynoldsNumber - 100_000) < tolerance)
        #expect(result.flowRegime == .turbulent)
        #expect(result.pressureDrop > 1_000)
        #expect(result.pressureDrop < 1_200)
        #expect(abs(result.pressureGradient - result.pressureDrop / 10) < tolerance)
    }

    @Test("Rejects a zero pipe length")
    func rejectsZeroPipeLength() {
        expectError(.invalidPipeLength) {
            _ = try engine.solve(
                input: PressureDropInput(
                    density: 1_000,
                    averageVelocity: 1,
                    pipeDiameter: 0.1,
                    pipeLength: 0,
                    dynamicViscosity: 0.001,
                    absoluteRoughness: 0
                )
            )
        }
    }

    private func expectError(
        _ expected: PressureDropError,
        operation: () throws -> Void
    ) {
        do {
            try operation()
            Issue.record("Expected \(expected) to be thrown.")
        } catch let error as PressureDropError {
            #expect(error == expected)
        } catch {
            Issue.record("Expected PressureDropError; received \(error).")
        }
    }
}
