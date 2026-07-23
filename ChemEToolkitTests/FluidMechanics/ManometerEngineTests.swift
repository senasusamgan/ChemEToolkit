import Foundation
import Testing
@testable import ChemEToolkit

@Suite("U-Tube Manometer Engine")
struct ManometerEngineTests {
    private let engine = ManometerEngine()
    private let tolerance = 1e-10

    @Test("Calculates pressure difference and pressure sides")
    func solvesReferenceCase() throws {
        let result = try engine.solve(
            input: ManometerInput(
                processFluidDensity: 1_000,
                manometerFluidDensity: 13_600,
                heightDifference: 0.2,
                lowerLevelSide: .left,
                gravity: 10
            )
        )

        #expect(abs(result.densityDifference - 12_600) < tolerance)
        #expect(abs(result.pressureDifference - 25_200) < tolerance)
        #expect(result.higherPressureSide == .left)
        #expect(result.lowerPressureSide == .right)
    }

    @Test("Reports equal pressures at zero height difference")
    func handlesEqualLevels() throws {
        let result = try engine.solve(
            input: ManometerInput(
                processFluidDensity: 1_000,
                manometerFluidDensity: 1_200,
                heightDifference: 0,
                lowerLevelSide: .right
            )
        )

        #expect(result.pressureDifference == 0)
        #expect(result.pressuresAreEqual)
        #expect(result.higherPressureSide == nil)
        #expect(result.lowerPressureSide == nil)
    }

    @Test("Rejects a manometer fluid that is not denser")
    func rejectsInsufficientManometerDensity() {
        expectError(.manometerFluidMustBeDenser) {
            _ = try engine.solve(
                input: ManometerInput(
                    processFluidDensity: 1_000,
                    manometerFluidDensity: 900,
                    heightDifference: 0.1,
                    lowerLevelSide: .left
                )
            )
        }
    }

    private func expectError(
        _ expected: ManometerError,
        operation: () throws -> Void
    ) {
        do {
            try operation()
            Issue.record("Expected \(expected) to be thrown.")
        } catch let error as ManometerError {
            #expect(error == expected)
        } catch {
            Issue.record("Expected ManometerError; received \(error).")
        }
    }
}
