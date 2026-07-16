import Foundation

enum ProportionalControllerError: Error, Equatable, LocalizedError {
    case nonFiniteInput
    case invalidOutputLimits
    case numericalFailure
    var errorDescription: String? {
        switch self {
        case .nonFiniteInput: return "All proportional-controller inputs must be finite."
        case .invalidOutputLimits: return "Minimum output must be less than maximum output."
        case .numericalFailure: return "The proportional-controller calculation failed."
        }
    }
}
