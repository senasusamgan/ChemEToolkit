import Foundation

enum InversePowerMethodEigenvalueError: Error, Equatable, LocalizedError {
    case nonFiniteInput
case zeroInitialVector
case invalidTolerance
case invalidIterationLimit
case singularShiftedMatrix
case didNotConverge

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput: return "Matrix, shift, vector and solver inputs must be finite."
    case .zeroInitialVector: return "Initial vector cannot be zero."
    case .invalidTolerance: return "Tolerance must be greater than zero."
    case .invalidIterationLimit: return "Maximum iterations must be a positive whole number."
    case .singularShiftedMatrix: return "Shifted matrix is singular or nearly singular."
    case .didNotConverge: return "The inverse power method did not converge."
        }
    }
}
