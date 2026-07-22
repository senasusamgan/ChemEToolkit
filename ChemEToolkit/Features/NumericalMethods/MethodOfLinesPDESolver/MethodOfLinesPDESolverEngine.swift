import Foundation

struct MethodOfLinesPDESolverEngine {
    func solve(_ input: MethodOfLinesPDESolverInput) throws -> MethodOfLinesPDESolverResult {
        let values = [
            input.diffusivity,
            input.reactionRateConstant,
            input.length,
            input.totalTime,
            input.initialConcentration,
            input.leftBoundaryConcentration,
            input.rightBoundaryConcentration
        ]
        guard values.allSatisfy(\.isFinite) else {
            throw MethodOfLinesPDESolverError.nonFiniteInput
        }
        guard input.diffusivity > 0,
              input.reactionRateConstant >= 0,
              input.length > 0,
              input.totalTime > 0,
              input.initialConcentration >= 0,
              input.leftBoundaryConcentration >= 0,
              input.rightBoundaryConcentration >= 0 else {
            throw MethodOfLinesPDESolverError.invalidPhysicalValues
        }
        guard input.spatialNodes >= 3, input.timeSteps >= 1 else {
            throw MethodOfLinesPDESolverError.invalidGrid
        }

        let dx = input.length / Double(input.spatialNodes - 1)
        let dt = input.totalTime / Double(input.timeSteps)
        let diffusionNumber = input.diffusivity * dt / (dx * dx)
        let reactionNumber = input.reactionRateConstant * dt
        guard diffusionNumber <= 0.5 + 1e-12, reactionNumber <= 1 + 1e-12 else {
            throw MethodOfLinesPDESolverError.unstableTimeStep
        }

        let positions = (0..<input.spatialNodes).map { Double($0) * dx }
        var state = positions.map { position -> Double in
            switch input.initialProfile {
            case .uniform:
                return input.initialConcentration
            case .sinePulse:
                return input.initialConcentration * sin(Double.pi * position / input.length)
            }
        }
        state[0] = input.leftBoundaryConcentration
        state[state.count - 1] = input.rightBoundaryConcentration

        func applyingBoundaries(_ values: [Double]) -> [Double] {
            var bounded = values
            bounded[0] = input.leftBoundaryConcentration
            bounded[bounded.count - 1] = input.rightBoundaryConcentration
            return bounded
        }

        func derivative(_ values: [Double]) -> [Double] {
            let bounded = applyingBoundaries(values)
            var rate = Array(repeating: 0.0, count: bounded.count)
            for index in 1..<(bounded.count - 1) {
                let laplacian = (bounded[index + 1] - 2 * bounded[index] + bounded[index - 1]) / (dx * dx)
                rate[index] = input.diffusivity * laplacian - input.reactionRateConstant * bounded[index]
            }
            return rate
        }

        for _ in 0..<input.timeSteps {
            let k1 = derivative(state)
            let stage2 = zip(state, k1).map { pair in pair.0 + 0.5 * dt * pair.1 }
            let k2 = derivative(stage2)
            let stage3 = zip(state, k2).map { pair in pair.0 + 0.5 * dt * pair.1 }
            let k3 = derivative(stage3)
            let stage4 = zip(state, k3).map { pair in pair.0 + dt * pair.1 }
            let k4 = derivative(stage4)

            state = (0..<state.count).map { index in
                state[index] + dt * (k1[index] + 2 * k2[index] + 2 * k3[index] + k4[index]) / 6
            }
            state = applyingBoundaries(state)
            guard state.allSatisfy(\.isFinite) else {
                throw MethodOfLinesPDESolverError.nonFiniteSolution
            }
        }

        return MethodOfLinesPDESolverResult(
            positions: positions,
            concentrations: state,
            spatialStep: dx,
            timeStep: dt,
            diffusionNumber: diffusionNumber,
            reactionNumber: reactionNumber
        )
    }
}
