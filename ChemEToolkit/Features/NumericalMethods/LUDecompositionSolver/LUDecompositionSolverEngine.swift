import Foundation

struct LUDecompositionSolverEngine {
    func solve(_ input: LUDecompositionSolverInput) throws -> LUDecompositionSolverResult {
        let a0 = input.matrix
        let b0 = input.constants
        let n = a0.count
        guard n > 0, b0.count == n, a0.allSatisfy({ $0.count == n }) else {
            throw LUDecompositionSolverError.invalidDimensions
        }
        guard input.pivotTolerance.isFinite, input.pivotTolerance > 0 else {
            throw LUDecompositionSolverError.invalidTolerance
        }
        guard a0.flatMap({ $0 }).allSatisfy(\.isFinite), b0.allSatisfy(\.isFinite) else {
            throw LUDecompositionSolverError.nonFiniteInput
        }

        var lu = a0
        var permutation = Array(0..<n)
        for k in 0..<n {
            var pivot = k
            var magnitude = abs(lu[k][k])
            if k + 1 < n {
                for row in (k + 1)..<n where abs(lu[row][k]) > magnitude {
                    pivot = row
                    magnitude = abs(lu[row][k])
                }
            }
            guard magnitude > input.pivotTolerance else { throw LUDecompositionSolverError.singularMatrix }
            if pivot != k {
                lu.swapAt(pivot, k)
                permutation.swapAt(pivot, k)
            }
            if k + 1 < n {
                for row in (k + 1)..<n {
                    lu[row][k] /= lu[k][k]
                    for column in (k + 1)..<n {
                        lu[row][column] -= lu[row][k] * lu[k][column]
                    }
                }
            }
        }

        let pb = permutation.map { b0[$0] }
        var y = Array(repeating: 0.0, count: n)
        for row in 0..<n {
            y[row] = pb[row] - (0..<row).reduce(0.0) { $0 + lu[row][$1] * y[$1] }
        }
        var x = Array(repeating: 0.0, count: n)
        for row in stride(from: n - 1, through: 0, by: -1) {
            let sum = ((row + 1)..<n).reduce(0.0) { $0 + lu[row][$1] * x[$1] }
            guard abs(lu[row][row]) > input.pivotTolerance else { throw LUDecompositionSolverError.singularMatrix }
            x[row] = (y[row] - sum) / lu[row][row]
        }

        var lower = Array(repeating: Array(repeating: 0.0, count: n), count: n)
        var upper = lower
        for row in 0..<n {
            lower[row][row] = 1
            for column in 0..<n {
                if row > column { lower[row][column] = lu[row][column] }
                else { upper[row][column] = lu[row][column] }
            }
        }
        let residual = zip(a0, b0).map { pair in
            zip(pair.0, x).reduce(0.0) { $0 + $1.0 * $1.1 } - pair.1
        }
        return .init(solution: x, lowerMatrix: lower, upperMatrix: upper,
                     permutation: permutation, residualNorm: sqrt(residual.reduce(0) { $0 + $1 * $1 }))
    }
}
