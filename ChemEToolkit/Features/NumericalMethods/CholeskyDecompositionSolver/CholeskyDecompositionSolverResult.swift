struct CholeskyDecompositionSolverResult: Equatable, Sendable {
    let solution: [Double]
    let lowerMatrix: [[Double]]
    let residualNorm: Double
}
