import Foundation
struct NewtonRaphsonNonlinearSystemEngine {
    func solve(_ input: NewtonRaphsonNonlinearSystemInput) throws -> NewtonRaphsonNonlinearSystemResult {
        try validate(input)
        func values(_ x: [Double]) -> [Double] {
            switch input.system {
            case .circleAndLine: return [x[0] * x[0] + x[1] * x[1] - 1, x[0] - x[1]]
            case .equilibriumBalance: return [x[0] + x[1] - 1, x[0] * x[1] - input.parameter]
            }
        }
        var x = input.initialGuess
        for iteration in 0..<input.maximumIterations {
            let f = values(x), norm = hypot(f[0], f[1])
            if norm <= input.tolerance { return .init(solution: x, iterations: iteration, residualNorm: norm) }
            let h = sqrt(Double.ulpOfOne) * max(1, max(abs(x[0]), abs(x[1])))
            var j = Array(repeating: Array(repeating: 0.0, count: 2), count: 2)
            for column in 0..<2 {
                var shifted = x; shifted[column] += h
                let shiftedValues = values(shifted)
                for row in 0..<2 { j[row][column] = (shiftedValues[row] - f[row]) / h }
            }
            let determinant = j[0][0] * j[1][1] - j[0][1] * j[1][0]
            guard abs(determinant) > 1e-14 else { throw NewtonRaphsonNonlinearSystemError.singularJacobian }
            let dx0 = (-f[0] * j[1][1] + j[0][1] * f[1]) / determinant
            let dx1 = (-j[0][0] * f[1] + f[0] * j[1][0]) / determinant
            x[0] += dx0; x[1] += dx1
        }
        throw NewtonRaphsonNonlinearSystemError.didNotConverge
    }
    private func validate(_ input: NewtonRaphsonNonlinearSystemInput) throws {
        guard input.initialGuess.count == 2, input.initialGuess.allSatisfy(\.isFinite) else { throw NewtonRaphsonNonlinearSystemError.invalidInitialGuess }
        guard input.tolerance.isFinite, input.tolerance > 0, input.maximumIterations > 0 else { throw NewtonRaphsonNonlinearSystemError.invalidControls }
        if input.system == .equilibriumBalance { guard input.parameter.isFinite, (0...0.25).contains(input.parameter) else { throw NewtonRaphsonNonlinearSystemError.invalidParameter } }
    }
}
