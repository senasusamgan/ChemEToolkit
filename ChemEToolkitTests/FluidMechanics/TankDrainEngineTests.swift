import Foundation
import Testing
@testable import ChemEToolkit

@Suite("Tank Drain Engine")
struct TankDrainEngineTests {
    private let engine = TankDrainEngine()
    private let tolerance = 1e-10

    @Test("Calculates drain time and endpoint flow rates")
    func solvesReferenceCase() throws {
        let result = try engine.solve(
            input: TankDrainInput(
                tankCrossSectionalArea: 2,
                orificeArea: 0.01,
                dischargeCoefficient: 0.5,
                initialLiquidHeight: 4,
                finalLiquidHeight: 1,
                gravity: 10
            )
        )
        let expectedTime = 4 / (0.005 * sqrt(20))

        #expect(abs(result.drainTime - expectedTime) < tolerance)
        #expect(abs(result.initialExitVelocity - sqrt(80)) < tolerance)
        #expect(abs(result.finalExitVelocity - sqrt(20)) < tolerance)
        #expect(abs(result.initialFlowRate - 0.005 * sqrt(80)) < tolerance)
        #expect(abs(result.finalFlowRate - 0.005 * sqrt(20)) < tolerance)
    }

    @Test("Returns zero time when initial and final heights match")
    func handlesEqualHeights() throws {
        let result = try engine.solve(
            input: TankDrainInput(
                tankCrossSectionalArea: 1,
                orificeArea: 0.01,
                dischargeCoefficient: 0.6,
                initialLiquidHeight: 2,
                finalLiquidHeight: 2
            )
        )

        #expect(abs(result.drainTime) < tolerance)
        #expect(abs(result.initialExitVelocity - result.finalExitVelocity) < tolerance)
        #expect(abs(result.initialFlowRate - result.finalFlowRate) < tolerance)
    }

    @Test("Rejects a final height above the initial height")
    func rejectsIncreasingLiquidHeight() {
        expectError(.finalHeightExceedsInitialHeight) {
            _ = try engine.solve(
                input: TankDrainInput(
                    tankCrossSectionalArea: 1,
                    orificeArea: 0.01,
                    dischargeCoefficient: 0.6,
                    initialLiquidHeight: 1,
                    finalLiquidHeight: 2
                )
            )
        }
    }

    private func expectError(
        _ expected: TankDrainError,
        operation: () throws -> Void
    ) {
        do {
            try operation()
            Issue.record("Expected \(expected) to be thrown.")
        } catch let error as TankDrainError {
            #expect(error == expected)
        } catch {
            Issue.record("Expected TankDrainError; received \(error).")
        }
    }
}
