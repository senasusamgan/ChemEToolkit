import Foundation
import Testing
@testable import ChemEToolkit

@Suite("Particle Settling Engine")
struct ParticleSettlingEngineTests {
    private let engine = ParticleSettlingEngine()
    private let tolerance = 1e-12

    @Test("Calculates Stokes settling velocity and Reynolds number")
    func solvesSettlingCase() throws {
        let result = try engine.solve(
            input: ParticleSettlingInput(
                particleDensity: 2_500,
                fluidDensity: 1_000,
                particleDiameter: 0.0001,
                dynamicViscosity: 0.001,
                gravity: 10
            )
        )

        #expect(abs(result.signedTerminalVelocity - 1.0 / 120.0) < tolerance)
        #expect(abs(result.terminalSpeed - 1.0 / 120.0) < tolerance)
        #expect(abs(result.particleReynoldsNumber - 5.0 / 6.0) < tolerance)
        #expect(result.motionDirection == .settling)
        #expect(result.isWithinStokesRegime)
    }

    @Test("Represents a buoyant particle with negative signed velocity")
    func solvesRisingCase() throws {
        let result = try engine.solve(
            input: ParticleSettlingInput(
                particleDensity: 500,
                fluidDensity: 1_000,
                particleDiameter: 0.00005,
                dynamicViscosity: 0.001,
                gravity: 10
            )
        )

        #expect(result.signedTerminalVelocity < 0)
        #expect(result.terminalSpeed > 0)
        #expect(result.motionDirection == .rising)
        #expect(abs(result.terminalSpeed - abs(result.signedTerminalVelocity)) < tolerance)
    }

    @Test("Rejects a zero dynamic viscosity")
    func rejectsZeroViscosity() {
        expectError(.invalidDynamicViscosity) {
            _ = try engine.solve(
                input: ParticleSettlingInput(
                    particleDensity: 2_500,
                    fluidDensity: 1_000,
                    particleDiameter: 0.0001,
                    dynamicViscosity: 0
                )
            )
        }
    }

    private func expectError(
        _ expected: ParticleSettlingError,
        operation: () throws -> Void
    ) {
        do {
            try operation()
            Issue.record("Expected \(expected) to be thrown.")
        } catch let error as ParticleSettlingError {
            #expect(error == expected)
        } catch {
            Issue.record("Expected ParticleSettlingError; received \(error).")
        }
    }
}
