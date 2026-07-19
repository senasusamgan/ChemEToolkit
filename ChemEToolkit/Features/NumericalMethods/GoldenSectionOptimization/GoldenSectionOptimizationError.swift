import Foundation

enum GoldenSectionOptimizationError: Error, Equatable, LocalizedError {
    case nonFiniteInput
case nonConvexQuadratic
case invalidBounds
case invalidTolerance
case invalidIterationLimit
case didNotConverge

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput: return "Objective, bounds and solver settings must be finite."
    case .nonConvexQuadratic: return "Quadratic coefficient a must be greater than zero."
    case .invalidBounds: return "Upper bound must exceed lower bound."
    case .invalidTolerance: return "Tolerance must be greater than zero."
    case .invalidIterationLimit: return "Maximum iterations must be a positive whole number."
    case .didNotConverge: return "The golden-section search did not converge."
        }
    }
}
