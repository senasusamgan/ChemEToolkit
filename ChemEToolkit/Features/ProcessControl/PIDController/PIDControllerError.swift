import Foundation

enum PIDControllerError: Error, Equatable, LocalizedError {
    case nonFiniteInput
    case nonPositiveIntegralTime
    case negativeDerivativeTime
    case invalidOutputLimits
    case numericalFailure
    var errorDescription: String? {
        switch self {
        case .nonFiniteInput: return "All PID-controller inputs must be finite."
        case .nonPositiveIntegralTime: return "Integral time must be greater than zero."
        case .negativeDerivativeTime: return "Derivative time cannot be negative."
        case .invalidOutputLimits: return "Minimum output must be less than maximum output."
        case .numericalFailure: return "The PID-controller calculation failed."
        }
    }
}
