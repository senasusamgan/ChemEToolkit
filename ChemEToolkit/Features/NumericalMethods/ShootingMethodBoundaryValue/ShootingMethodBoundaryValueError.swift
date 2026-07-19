import Foundation

enum ShootingMethodBoundaryValueError: Error, Equatable, LocalizedError {
    case nonFiniteInput
case invalidInterval
case invalidStep
case invalidTolerance
case invalidIterationLimit
case secantFailure
case didNotConverge

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput: return "Equation, boundary and solver inputs must be finite."
    case .invalidInterval: return "Final x must exceed initial x."
    case .invalidStep: return "Step size must be positive and no larger than the interval."
    case .invalidTolerance: return "Tolerance must be greater than zero."
    case .invalidIterationLimit: return "Maximum iterations must be a positive whole number."
    case .secantFailure: return "The shooting secant update became singular."
    case .didNotConverge: return "The shooting method did not converge."
        }
    }
}
