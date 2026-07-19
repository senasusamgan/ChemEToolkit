import Foundation
struct ConjugateGradientSolverEngine {
    func solve(_ input: ConjugateGradientSolverInput) throws -> ConjugateGradientSolverResult {
        let a = input.matrix, b = input.constants, n = a.count
        guard n > 0, b.count == n, input.initialGuess.count == n, a.allSatisfy({ $0.count == n }) else { throw ConjugateGradientSolverError.invalidDimensions }
        guard input.tolerance.isFinite, input.tolerance > 0, input.maximumIterations > 0 else { throw ConjugateGradientSolverError.invalidControls }
        guard a.flatMap({ $0 }).allSatisfy(\.isFinite), b.allSatisfy(\.isFinite), input.initialGuess.allSatisfy(\.isFinite) else { throw ConjugateGradientSolverError.nonFiniteInput }
        for i in 0..<n { for j in 0..<i where abs(a[i][j] - a[j][i]) > 1e-10 { throw ConjugateGradientSolverError.notSymmetric } }
        func multiply(_ vector: [Double]) -> [Double] { a.map { row in zip(row, vector).reduce(0.0) { $0 + $1.0 * $1.1 } } }
        func dot(_ lhs: [Double], _ rhs: [Double]) -> Double { zip(lhs, rhs).reduce(0.0) { $0 + $1.0 * $1.1 } }
        var x = input.initialGuess
        var r = zip(b, multiply(x)).map { $0.0 - $0.1 }
        var p = r
        var rr = dot(r, r)
        var history = [sqrt(rr)]
        if history[0] <= input.tolerance { return .init(solution: x, iterations: 0, residualNorm: history[0], residualHistory: history) }
        for iteration in 1...input.maximumIterations {
            let ap = multiply(p), denominator = dot(p, ap)
            guard denominator > 0 else { throw ConjugateGradientSolverError.notPositiveDefinite }
            let alpha = rr / denominator
            x = zip(x, p).map { $0.0 + alpha * $0.1 }
            r = zip(r, ap).map { $0.0 - alpha * $0.1 }
            let nextRR = dot(r, r), norm = sqrt(nextRR)
            history.append(norm)
            if norm <= input.tolerance { return .init(solution: x, iterations: iteration, residualNorm: norm, residualHistory: history) }
            let beta = nextRR / rr
            p = zip(r, p).map { $0.0 + beta * $0.1 }
            rr = nextRR
        }
        throw ConjugateGradientSolverError.didNotConverge
    }
}
