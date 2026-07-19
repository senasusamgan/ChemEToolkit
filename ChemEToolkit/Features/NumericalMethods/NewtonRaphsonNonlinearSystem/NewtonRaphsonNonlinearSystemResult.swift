struct NewtonRaphsonNonlinearSystemResult: Equatable, Sendable {
    let solution: [Double]
    let iterations: Int
    let residualNorm: Double
}
