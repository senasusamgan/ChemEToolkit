import Foundation

enum PowerMethodEigenvalueError: Error, Equatable, LocalizedError {
    case nonFiniteInput
case zeroInitialVector
case invalidTolerance
case invalidIterationLimit
case singularIteration
case didNotConverge

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput: return "Matrix, vector and solver inputs must be finite."
    case .zeroInitialVector: return "Initial vector cannot be zero."
    case .invalidTolerance: return "Tolerance must be greater than zero."
    case .invalidIterationLimit: return "Maximum iterations must be a positive whole number."
    case .singularIteration: return "The iteration produced a zero vector."
    case .didNotConverge: return "The power method did not converge."
        }
    }
}
