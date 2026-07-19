import Foundation
enum ConjugateGradientSolverError: Error, Equatable, LocalizedError {
    case invalidDimensions, nonFiniteInput, invalidControls, notSymmetric, notPositiveDefinite, didNotConverge
    var errorDescription: String? {
        switch self {
        case .invalidDimensions: return "The matrix must be nonempty and square; vectors must match its dimension."
        case .nonFiniteInput: return "All numeric inputs must be finite."
        case .invalidControls: return "Tolerance and maximum iterations must be greater than zero."
        case .notSymmetric: return "Conjugate gradient requires a symmetric matrix."
        case .notPositiveDefinite: return "The search direction detected a non-positive-definite matrix."
        case .didNotConverge: return "The solver did not converge within the iteration limit."
        }
    }
}
