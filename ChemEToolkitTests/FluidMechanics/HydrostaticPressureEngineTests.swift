import Foundation
import Testing
@testable import ChemEToolkit

@Suite("Hydrostatic Pressure Engine")
struct HydrostaticPressureEngineTests {
    private let engine = HydrostaticPressureEngine()
    private let tolerance = 1e-10

    @Test("Calculates gauge increase and absolute pressure at depth")
    func solvesReferenceCase() throws {
        let result = try engine.solve(
            input: HydrostaticPressureInput(
                fluidDensity: 1_000,
                depth: 3,
                surfacePressure: 100_000,
                gravity: 10
            )
        )

        #expect(abs(result.pressureIncrease - 30_000) < tolerance)
        #expect(abs(result.pressureAtDepth - 130_000) < tolerance)
        #expect(abs(result.pressureHead - 3) < tolerance)
    }

    @Test("Preserves surface pressure at zero depth")
    func handlesZeroDepth() throws {
        let result = try engine.solve(
            input: HydrostaticPressureInput(
                fluidDensity: 998,
                depth: 0,
                surfacePressure: 101_325
            )
        )

        #expect(result.pressureIncrease == 0)
        #expect(result.pressureAtDepth == 101_325)
        #expect(result.pressureHead == 0)
    }

    @Test("Rejects a negative depth")
    func rejectsNegativeDepth() {
        expectError(.invalidDepth) {
            _ = try engine.solve(
                input: HydrostaticPressureInput(
                    fluidDensity: 1_000,
                    depth: -1,
                    surfacePressure: 101_325
                )
            )
        }
    }

    private func expectError(
        _ expected: HydrostaticPressureError,
        operation: () throws -> Void
    ) {
        do {
            try operation()
            Issue.record("Expected \(expected) to be thrown.")
        } catch let error as HydrostaticPressureError {
            #expect(error == expected)
        } catch {
            Issue.record("Expected HydrostaticPressureError; received \(error).")
        }
    }
}
