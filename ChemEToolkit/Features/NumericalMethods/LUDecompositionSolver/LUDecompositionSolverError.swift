import Foundation

enum LUDecompositionSolverError: Error, Equatable, LocalizedError {
    case invalidDimensions
    case nonFiniteInput
    case invalidTolerance
    case singularMatrix

    var errorDescription: String? {
        switch self {
        case .invalidDimensions: return "The matrix must be nonempty and square, and the vector size must match."
        case .nonFiniteInput: return "All matrix and vector values must be finite."
        case .invalidTolerance: return "Pivot tolerance must be finite and greater than zero."
        case .singularMatrix: return "The matrix is singular or numerically singular at the selected tolerance."
        }
    }
}
