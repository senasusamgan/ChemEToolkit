import Foundation
struct BroydenNonlinearSystemEngine {
    func solve(_ input: BroydenNonlinearSystemInput) throws -> BroydenNonlinearSystemResult {
        try validate(input)
        func values(_ x: [Double]) -> [Double] {
            switch input.system {
            case .circleAndLine: return [x[0] * x[0] + x[1] * x[1] - 1, x[0] - x[1]]
            case .equilibriumBalance: return [x[0] + x[1] - 1, x[0] * x[1] - input.parameter]
            }
        }
        var x = input.initialGuess, f = values(x)
        let h = 1e-6
        var b = [[0.0, 0.0], [0.0, 0.0]]
        for column in 0..<2 {
            var shifted = x; shifted[column] += h
            let fp = values(shifted)
            for row in 0..<2 { b[row][column] = (fp[row] - f[row]) / h }
        }
        for iteration in 0..<input.maximumIterations {
            let norm = hypot(f[0], f[1])
            if norm <= input.tolerance { return .init(solution: x, iterations: iteration, residualNorm: norm) }
            let determinant = b[0][0] * b[1][1] - b[0][1] * b[1][0]
            guard abs(determinant) > 1e-14 else { throw BroydenNonlinearSystemError.singularJacobian }
            let step = [(-f[0] * b[1][1] + b[0][1] * f[1]) / determinant,
                        (-b[0][0] * f[1] + f[0] * b[1][0]) / determinant]
            let nextX = zip(x, step).map { $0.0 + $0.1 }, nextF = values(nextX)
            let y = zip(nextF, f).map { $0.0 - $0.1 }, bs = [b[0][0] * step[0] + b[0][1] * step[1], b[1][0] * step[0] + b[1][1] * step[1]]
            let denominator = step[0] * step[0] + step[1] * step[1]
            guard denominator > 1e-24 else { throw BroydenNonlinearSystemError.singularJacobian }
            for row in 0..<2 { for column in 0..<2 { b[row][column] += (y[row] - bs[row]) * step[column] / denominator } }
            x = nextX; f = nextF
        }
        throw BroydenNonlinearSystemError.didNotConverge
    }
    private func validate(_ input: BroydenNonlinearSystemInput) throws {
        guard input.initialGuess.count == 2, input.initialGuess.allSatisfy(\.isFinite) else { throw BroydenNonlinearSystemError.invalidInitialGuess }
        guard input.tolerance.isFinite, input.tolerance > 0, input.maximumIterations > 0 else { throw BroydenNonlinearSystemError.invalidControls }
        if input.system == .equilibriumBalance { guard input.parameter.isFinite, (0...0.25).contains(input.parameter) else { throw BroydenNonlinearSystemError.invalidParameter } }
    }
}
