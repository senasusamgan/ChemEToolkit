import Foundation

enum RatioControlError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case negativeWildStreamFlow
    case negativeDesiredRatio
    case invalidFlowLimits
    case negativeMeasuredControlledFlow
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All ratio-control inputs must be finite."
        case .negativeWildStreamFlow:
            return "Wild-stream flow cannot be negative."
        case .negativeDesiredRatio:
            return "Desired flow ratio cannot be negative."
        case .invalidFlowLimits:
            return "Minimum controlled flow must be nonnegative and less than maximum controlled flow."
        case .negativeMeasuredControlledFlow:
            return "Measured controlled-stream flow cannot be negative."
        case .numericalFailure:
            return "The ratio-control calculation did not produce finite results."
        }
    }
}
