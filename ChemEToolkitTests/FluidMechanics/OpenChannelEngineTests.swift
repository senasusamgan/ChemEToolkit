import Foundation
import Testing
@testable import ChemEToolkit

@Suite("Open Channel Engine")
struct OpenChannelEngineTests {
    private let engine = OpenChannelEngine()
    private let tolerance = 1e-10

    @Test("Solves Manning flow for a rectangular channel")
    func solvesReferenceCase() throws {
        let result = try engine.solve(
            input: OpenChannelInput(
                channelWidth: 3,
                flowDepth: 1,
                bedSlope: 0.01,
                manningCoefficient: 0.02
            )
        )
        let expectedFlowRate =
            15 * pow(0.6, 2.0 / 3.0)

        #expect(abs(result.crossSectionalArea - 3) < tolerance)
        #expect(abs(result.wettedPerimeter - 5) < tolerance)
        #expect(abs(result.hydraulicRadius - 0.6) < tolerance)
        #expect(abs(result.volumetricFlowRate - expectedFlowRate) < tolerance)
        #expect(abs(result.averageVelocity - expectedFlowRate / 3) < tolerance)
    }

    @Test("Flow rate scales with the square root of bed slope")
    func verifiesBedSlopeScaling() throws {
        let base = try engine.solve(
            input: OpenChannelInput(
                channelWidth: 2,
                flowDepth: 0.5,
                bedSlope: 0.01,
                manningCoefficient: 0.03
            )
        )
        let steeper = try engine.solve(
            input: OpenChannelInput(
                channelWidth: 2,
                flowDepth: 0.5,
                bedSlope: 0.04,
                manningCoefficient: 0.03
            )
        )

        #expect(abs(steeper.volumetricFlowRate - 2 * base.volumetricFlowRate) < tolerance)
        #expect(abs(steeper.averageVelocity - 2 * base.averageVelocity) < tolerance)
    }

    @Test("Rejects a zero bed slope")
    func rejectsZeroBedSlope() {
        expectError(.invalidBedSlope) {
            _ = try engine.solve(
                input: OpenChannelInput(
                    channelWidth: 2,
                    flowDepth: 1,
                    bedSlope: 0,
                    manningCoefficient: 0.03
                )
            )
        }
    }

    private func expectError(
        _ expected: OpenChannelError,
        operation: () throws -> Void
    ) {
        do {
            try operation()
            Issue.record("Expected \(expected) to be thrown.")
        } catch let error as OpenChannelError {
            #expect(error == expected)
        } catch {
            Issue.record("Expected OpenChannelError; received \(error).")
        }
    }
}
