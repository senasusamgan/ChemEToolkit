import Foundation
import Testing
@testable import ChemEToolkit

@Suite("Bernoulli Engine")
struct BernoulliEngineTests {
    private let engine = BernoulliEngine()
    private let tolerance = 1e-10

    @Test("Balances pressure, velocity, elevation, pump, turbine, and loss heads")
    func solvesCompleteEnergyBalance() throws {
        let result = try engine.solve(
            input: BernoulliInput(
                density: 1_000,
                gravity: 10,
                inlet: BernoulliPoint(
                    pressure: 200_000,
                    velocity: 2,
                    elevation: 5
                ),
                outletVelocity: 4,
                outletElevation: 2,
                pumpHead: 10,
                turbineHead: 3,
                headLoss: 4
            )
        )

        #expect(abs(result.inletTotalHead - 35.2) < tolerance)
        #expect(abs(result.outletPressureHead - 25.4) < tolerance)
        #expect(abs(result.outletPressure - 254_000) < tolerance)
        #expect(abs(result.outletTotalHead - result.inletTotalHead) < tolerance)
    }

    @Test("Preserves pressure when both points are identical")
    func preservesPressureForIdenticalPoints() throws {
        let result = try engine.solve(
            input: BernoulliInput(
                density: 998,
                inlet: BernoulliPoint(
                    pressure: 150_000,
                    velocity: 3,
                    elevation: 4
                ),
                outletVelocity: 3,
                outletElevation: 4
            )
        )

        #expect(abs(result.outletPressure - 150_000) < tolerance)
        #expect(abs(result.pressureChange) < tolerance)
    }

    @Test("Rejects a negative head loss")
    func rejectsNegativeHeadLoss() {
        expectError(.invalidHeadLoss) {
            _ = try engine.solve(
                input: BernoulliInput(
                    density: 1_000,
                    inlet: BernoulliPoint(
                        pressure: 100_000,
                        velocity: 1,
                        elevation: 0
                    ),
                    outletVelocity: 1,
                    outletElevation: 0,
                    headLoss: -0.1
                )
            )
        }
    }

    private func expectError(
        _ expected: BernoulliError,
        operation: () throws -> Void
    ) {
        do {
            try operation()
            Issue.record("Expected \(expected) to be thrown.")
        } catch let error as BernoulliError {
            #expect(error == expected)
        } catch {
            Issue.record("Expected BernoulliError; received \(error).")
        }
    }
}
