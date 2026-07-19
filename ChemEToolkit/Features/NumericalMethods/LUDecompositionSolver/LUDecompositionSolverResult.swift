struct LUDecompositionSolverResult: Equatable, Sendable {
    let solution: [Double]
    let lowerMatrix: [[Double]]
    let upperMatrix: [[Double]]
    let permutation: [Int]
    let residualNorm: Double
}
