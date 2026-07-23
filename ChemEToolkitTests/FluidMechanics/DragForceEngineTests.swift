import Foundation
import Testing
@testable import ChemEToolkit

@Suite("Drag Force Engine")
struct DragForceEngineTests {
    private let engine = DragForceEngine()
    private let tolerance = 1e-12

    @Test("Calculates dynamic pressure, drag force, and drag power")
    func solvesReferenceCase() throws {
        let result = try engine.solve(
            input: DragForceInput(
                fluidDensity: 1.2,
                relativeVelocity: 10,
                projectedArea: 2,
                dragCoefficient: 0.5
            )
        )

        #expect(abs(result.dynamicPressure - 60) < tolerance)
        #expect(abs(result.dragForce - 60) < tolerance)
        #expect(abs(result.dragPower - 600) < tolerance)
        #expect(abs(result.forcePerUnitArea - 30) < tolerance)
    }

    @Test("Returns zero force and power at zero relative velocity")
    func handlesZeroVelocity() throws {
        let result = try engine.solve(
            input: DragForceInput(
                fluidDensity: 1_000,
                relativeVelocity: 0,
                projectedArea: 0.25,
                dragCoefficient: 1.1
            )
        )

        #expect(result.dynamicPressure == 0)
        #expect(result.dragForce == 0)
        #expect(result.dragPower == 0)
    }

    @Test("Rejects a negative drag coefficient")
    func rejectsNegativeDragCoefficient() {
        expectError(.invalidDragCoefficient) {
            _ = try engine.solve(
                input: DragForceInput(
                    fluidDensity: 1.2,
                    relativeVelocity: 5,
                    projectedArea: 1,
                    dragCoefficient: -0.1
                )
            )
        }
    }

    private func expectError(
        _ expected: DragForceError,
        operation: () throws -> Void
    ) {
        do {
            try operation()
            Issue.record("Expected \(expected) to be thrown.")
        } catch let error as DragForceError {
            #expect(error == expected)
        } catch {
            Issue.record("Expected DragForceError; received \(error).")
        }
    }
}
