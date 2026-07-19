import Foundation

struct CholeskyDecompositionSolverEngine {
    func solve(_ input: CholeskyDecompositionSolverInput) throws -> CholeskyDecompositionSolverResult {
        let a = input.matrix, b = input.constants, n = a.count
        guard n > 0, b.count == n, a.allSatisfy({ $0.count == n }) else { throw CholeskyDecompositionSolverError.invalidDimensions }
        guard input.tolerance.isFinite, input.tolerance > 0 else { throw CholeskyDecompositionSolverError.invalidTolerance }
        guard a.flatMap({ $0 }).allSatisfy(\.isFinite), b.allSatisfy(\.isFinite) else { throw CholeskyDecompositionSolverError.nonFiniteInput }
        for i in 0..<n { for j in 0..<i where abs(a[i][j] - a[j][i]) > input.tolerance { throw CholeskyDecompositionSolverError.notSymmetric } }

        var l = Array(repeating: Array(repeating: 0.0, count: n), count: n)
        for i in 0..<n {
            for j in 0...i {
                let sum = (0..<j).reduce(0.0) { $0 + l[i][$1] * l[j][$1] }
                if i == j {
                    let diagonal = a[i][i] - sum
                    guard diagonal > input.tolerance else { throw CholeskyDecompositionSolverError.notPositiveDefinite }
                    l[i][j] = sqrt(diagonal)
                } else {
                    guard abs(l[j][j]) > input.tolerance else { throw CholeskyDecompositionSolverError.notPositiveDefinite }
                    l[i][j] = (a[i][j] - sum) / l[j][j]
                }
            }
        }
        var y = Array(repeating: 0.0, count: n)
        for i in 0..<n { y[i] = (b[i] - (0..<i).reduce(0.0) { $0 + l[i][$1] * y[$1] }) / l[i][i] }
        var x = Array(repeating: 0.0, count: n)
        for i in stride(from: n - 1, through: 0, by: -1) {
            x[i] = (y[i] - ((i + 1)..<n).reduce(0.0) { $0 + l[$1][i] * x[$1] }) / l[i][i]
        }
        let r = zip(a, b).map { pair in zip(pair.0, x).reduce(0.0) { $0 + $1.0 * $1.1 } - pair.1 }
        return .init(solution: x, lowerMatrix: l, residualNorm: sqrt(r.reduce(0) { $0 + $1 * $1 }))
    }
}
