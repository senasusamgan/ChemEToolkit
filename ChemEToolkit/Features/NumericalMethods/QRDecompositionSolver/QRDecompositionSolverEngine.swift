import Foundation
struct QRDecompositionSolverEngine {
    func solve(_ input: QRDecompositionSolverInput) throws -> QRDecompositionSolverResult {
        let a = input.matrix, b = input.constants, m = a.count
        guard m > 0, let n = a.first?.count, n > 0, m >= n, b.count == m, a.allSatisfy({ $0.count == n }) else { throw QRDecompositionSolverError.invalidDimensions }
        guard input.rankTolerance.isFinite, input.rankTolerance > 0 else { throw QRDecompositionSolverError.invalidTolerance }
        guard a.flatMap({ $0 }).allSatisfy(\.isFinite), b.allSatisfy(\.isFinite) else { throw QRDecompositionSolverError.nonFiniteInput }
        var qColumns = Array(repeating: Array(repeating: 0.0, count: m), count: n)
        var r = Array(repeating: Array(repeating: 0.0, count: n), count: n)
        for j in 0..<n {
            var v = a.map { $0[j] }
            for i in 0..<j {
                r[i][j] = zip(qColumns[i], v).reduce(0.0) { $0 + $1.0 * $1.1 }
                for row in 0..<m { v[row] -= r[i][j] * qColumns[i][row] }
            }
            r[j][j] = sqrt(v.reduce(0.0) { $0 + $1 * $1 })
            guard r[j][j] > input.rankTolerance else { throw QRDecompositionSolverError.rankDeficient }
            qColumns[j] = v.map { $0 / r[j][j] }
        }
        let qtb = qColumns.map { column in zip(column, b).reduce(0.0) { $0 + $1.0 * $1.1 } }
        var x = Array(repeating: 0.0, count: n)
        for i in stride(from: n - 1, through: 0, by: -1) {
            x[i] = (qtb[i] - ((i + 1)..<n).reduce(0.0) { $0 + r[i][$1] * x[$1] }) / r[i][i]
        }
        let residuals = zip(a, b).map { pair in zip(pair.0, x).reduce(0.0) { $0 + $1.0 * $1.1 } - pair.1 }
        let qRows = (0..<m).map { row in qColumns.map { $0[row] } }
        return .init(solution: x, orthogonalMatrix: qRows, upperTriangularMatrix: r,
                     residualNorm: sqrt(residuals.reduce(0) { $0 + $1 * $1 }))
    }
}
