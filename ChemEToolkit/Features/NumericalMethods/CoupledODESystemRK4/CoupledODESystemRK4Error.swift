import Foundation

enum CoupledODESystemRK4Error: Error, Equatable, LocalizedError {
    case nonFiniteInput
case nonPositiveFinalTime
case invalidStep
case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput: return "System coefficients, states and settings must be finite."
    case .nonPositiveFinalTime: return "Final time must be greater than zero."
    case .invalidStep: return "Step size must be positive and no larger than final time."
    case .numericalFailure: return "The coupled-system integration produced a nonfinite state."
        }
    }
}
