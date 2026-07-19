import Foundation
struct ThomasTridiagonalSolverEngine {
    func solve(_ input: ThomasTridiagonalSolverInput) throws -> ThomasTridiagonalSolverResult {
        let n = input.mainDiagonal.count
        guard n > 0, input.constants.count == n,
              input.lowerDiagonal.count == max(0, n - 1), input.upperDiagonal.count == max(0, n - 1) else { throw ThomasTridiagonalSolverError.invalidDimensions }
        guard input.pivotTolerance.isFinite, input.pivotTolerance > 0 else { throw ThomasTridiagonalSolverError.invalidTolerance }
        let all = input.lowerDiagonal + input.mainDiagonal + input.upperDiagonal + input.constants
        guard all.allSatisfy(\.isFinite) else { throw ThomasTridiagonalSolverError.nonFiniteInput }
        var d = input.mainDiagonal, rhs = input.constants
        guard abs(d[0]) > input.pivotTolerance else { throw ThomasTridiagonalSolverError.zeroPivot }
        if n > 1 {
            for i in 1..<n {
                let multiplier = input.lowerDiagonal[i - 1] / d[i - 1]
                d[i] -= multiplier * input.upperDiagonal[i - 1]
                rhs[i] -= multiplier * rhs[i - 1]
                guard abs(d[i]) > input.pivotTolerance else { throw ThomasTridiagonalSolverError.zeroPivot }
            }
        }
        var x = Array(repeating: 0.0, count: n)
        x[n - 1] = rhs[n - 1] / d[n - 1]
        if n > 1 { for i in stride(from: n - 2, through: 0, by: -1) { x[i] = (rhs[i] - input.upperDiagonal[i] * x[i + 1]) / d[i] } }
        var residuals = Array(repeating: 0.0, count: n)
        for i in 0..<n {
            var value = input.mainDiagonal[i] * x[i]
            if i > 0 { value += input.lowerDiagonal[i - 1] * x[i - 1] }
            if i + 1 < n { value += input.upperDiagonal[i] * x[i + 1] }
            residuals[i] = value - input.constants[i]
        }
        return .init(solution: x, residualNorm: sqrt(residuals.reduce(0) { $0 + $1 * $1 }))
    }
}
