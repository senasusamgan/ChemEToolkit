struct ConjugateGradientSolverInput: Equatable, Sendable {
    let matrix: [[Double]]
    let constants: [Double]
    let initialGuess: [Double]
    let tolerance: Double
    let maximumIterations: Int
    init(matrix: [[Double]], constants: [Double], initialGuess: [Double], tolerance: Double = 1e-10, maximumIterations: Int = 500) {
        self.matrix = matrix; self.constants = constants; self.initialGuess = initialGuess
        self.tolerance = tolerance; self.maximumIterations = maximumIterations
    }
}
