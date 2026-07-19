import Foundation

struct LUDecompositionSolverInput: Equatable, Sendable {
    let matrix: [[Double]]
    let constants: [Double]
    let pivotTolerance: Double

    init(matrix: [[Double]], constants: [Double], pivotTolerance: Double = 1e-12) {
        self.matrix = matrix
        self.constants = constants
        self.pivotTolerance = pivotTolerance
    }
}
