import Foundation
import Testing
@testable import ChemEToolkit

@Suite("Method of Lines PDE Solver Engine")
struct MethodOfLinesPDESolverEngineTests {
    @Test("Matches the analytical reacting sine mode")
    func analyticalReference() throws {
        let diffusivity = 0.1
        let reactionRate = 0.2
        let time = 0.1
        let result = try MethodOfLinesPDESolverEngine().solve(
            .init(
                diffusivity: diffusivity,
                reactionRateConstant: reactionRate,
                length: 1,
                totalTime: time,
                spatialNodes: 101,
                timeSteps: 2_000,
                initialConcentration: 1
            )
        )
        let expected = exp(-(diffusivity * Double.pi * Double.pi + reactionRate) * time)
        #expect(abs(result.concentrations[50] - expected) < 0.00002)
    }

    @Test("Grid refinement reduces the center error")
    func refinementTrend() throws {
        let engine = MethodOfLinesPDESolverEngine()
        let coarse = try engine.solve(
            .init(diffusivity: 0.1, reactionRateConstant: 0.2, length: 1, totalTime: 0.1, spatialNodes: 21, timeSteps: 100, initialConcentration: 1)
        )
        let fine = try engine.solve(
            .init(diffusivity: 0.1, reactionRateConstant: 0.2, length: 1, totalTime: 0.1, spatialNodes: 81, timeSteps: 1_600, initialConcentration: 1)
        )
        let expected = exp(-(0.1 * Double.pi * Double.pi + 0.2) * 0.1)
        #expect(abs(fine.concentrations[40] - expected) < abs(coarse.concentrations[10] - expected))
    }

    @Test("Rejects an unstable time step")
    func unstableStep() {
        #expect(throws: MethodOfLinesPDESolverError.unstableTimeStep) {
            try MethodOfLinesPDESolverEngine().solve(
                .init(diffusivity: 1, length: 1, totalTime: 1, spatialNodes: 11, timeSteps: 10, initialConcentration: 1)
            )
        }
    }
}
