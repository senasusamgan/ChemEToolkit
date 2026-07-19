struct QRDecompositionSolverInput: Equatable, Sendable {
    let matrix: [[Double]]
    let constants: [Double]
    let rankTolerance: Double
    init(matrix: [[Double]], constants: [Double], rankTolerance: Double = 1e-12) {
        self.matrix = matrix; self.constants = constants; self.rankTolerance = rankTolerance
    }
}
