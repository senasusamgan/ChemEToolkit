struct CholeskyDecompositionSolverInput: Equatable, Sendable {
    let matrix: [[Double]]
    let constants: [Double]
    let tolerance: Double

    init(matrix: [[Double]], constants: [Double], tolerance: Double = 1e-12) {
        self.matrix = matrix
        self.constants = constants
        self.tolerance = tolerance
    }
}
