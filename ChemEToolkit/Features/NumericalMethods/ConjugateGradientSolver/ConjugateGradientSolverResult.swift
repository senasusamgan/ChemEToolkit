struct ConjugateGradientSolverResult: Equatable, Sendable {
    let solution: [Double]
    let iterations: Int
    let residualNorm: Double
    let residualHistory: [Double]
}
