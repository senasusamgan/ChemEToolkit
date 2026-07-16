import Foundation

enum PIControllerError: Error, Equatable, LocalizedError {
    case nonFiniteInput
    case nonPositiveIntegralTime
    case invalidOutputLimits
    case numericalFailure
    var errorDescription: String? {
        switch self {
        case .nonFiniteInput: return "All PI-controller inputs must be finite."
        case .nonPositiveIntegralTime: return "Integral time must be greater than zero."
        case .invalidOutputLimits: return "Minimum output must be less than maximum output."
        case .numericalFailure: return "The PI-controller calculation failed."
        }
    }
}
