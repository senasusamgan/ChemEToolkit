import Foundation

enum CholeskyDecompositionSolverError: Error, Equatable, LocalizedError {
    case invalidDimensions, nonFiniteInput, invalidTolerance, notSymmetric, notPositiveDefinite
    var errorDescription: String? {
        switch self {
        case .invalidDimensions: return "The matrix must be nonempty and square, with a matching constant vector."
        case .nonFiniteInput: return "All inputs must be finite."
        case .invalidTolerance: return "Tolerance must be finite and greater than zero."
        case .notSymmetric: return "Cholesky decomposition requires a symmetric matrix."
        case .notPositiveDefinite: return "Cholesky decomposition requires a positive-definite matrix."
        }
    }
}
