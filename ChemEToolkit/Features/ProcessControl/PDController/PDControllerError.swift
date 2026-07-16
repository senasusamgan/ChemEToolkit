import Foundation

enum PDControllerError: Error, Equatable, LocalizedError {
    case nonFiniteInput
    case negativeDerivativeTime
    case invalidOutputLimits
    case numericalFailure
    var errorDescription: String? {
        switch self {
        case .nonFiniteInput: return "All PD-controller inputs must be finite."
        case .negativeDerivativeTime: return "Derivative time cannot be negative."
        case .invalidOutputLimits: return "Minimum output must be less than maximum output."
        case .numericalFailure: return "The PD-controller calculation failed."
        }
    }
}
