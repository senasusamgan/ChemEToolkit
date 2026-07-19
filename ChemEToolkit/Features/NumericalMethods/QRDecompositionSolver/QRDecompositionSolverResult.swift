struct QRDecompositionSolverResult: Equatable, Sendable {
    let solution: [Double]
    let orthogonalMatrix: [[Double]]
    let upperTriangularMatrix: [[Double]]
    let residualNorm: Double
}
