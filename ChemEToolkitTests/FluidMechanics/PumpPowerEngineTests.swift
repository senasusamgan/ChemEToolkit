import Foundation
import Testing
@testable import ChemEToolkit

@Suite("Pump Power Engine")
struct PumpPowerEngineTests {
    private let engine = PumpPowerEngine()
    private let tolerance = 1e-10

    @Test("Calculates pressure increase, hydraulic power, and shaft power")
    func solvesReferenceCase() throws {
        let result = try engine.solve(
            input: PumpPowerInput(
                density: 1_000,
                volumetricFlowRate: 0.1,
                pumpHead: 20,
                efficiency: 0.8,
                gravity: 10
            )
        )

        #expect(abs(result.pressureIncrease - 200_000) < tolerance)
        #expect(abs(result.hydraulicPower - 20_000) < tolerance)
        #expect(abs(result.shaftPower - 25_000) < tolerance)
        #expect(abs(result.powerLoss - 5_000) < tolerance)
    }

    @Test("Returns zero power for zero flow")
    func handlesZeroFlow() throws {
        let result = try engine.solve(
            input: PumpPowerInput(
                density: 1_000,
                volumetricFlowRate: 0,
                pumpHead: 20,
                efficiency: 0.75
            )
        )

        #expect(result.hydraulicPower == 0)
        #expect(result.shaftPower == 0)
        #expect(result.powerLoss == 0)
    }

    @Test("Rejects efficiency above one")
    func rejectsEfficiencyAboveOne() {
        expectError(.invalidEfficiency) {
            _ = try engine.solve(
                input: PumpPowerInput(
                    density: 1_000,
                    volumetricFlowRate: 0.1,
                    pumpHead: 20,
                    efficiency: 1.01
                )
            )
        }
    }

    private func expectError(
        _ expected: PumpPowerError,
        operation: () throws -> Void
    ) {
        do {
            try operation()
            Issue.record("Expected \(expected) to be thrown.")
        } catch let error as PumpPowerError {
            #expect(error == expected)
        } catch {
            Issue.record("Expected PumpPowerError; received \(error).")
        }
    }
}
