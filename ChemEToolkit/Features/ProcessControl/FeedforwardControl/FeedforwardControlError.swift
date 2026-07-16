import Foundation

enum FeedforwardControlError: Error, Equatable, LocalizedError {
    case nonFiniteInput
    case zeroManipulatedPathGain
    case invalidControllerLimits
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput: return "All feedforward-control inputs must be finite."
        case .zeroManipulatedPathGain: return "Manipulated-variable path gain cannot be zero."
        case .invalidControllerLimits: return "Minimum controller output must be less than maximum controller output."
        case .numericalFailure: return "The feedforward-control calculation did not produce finite results."
        }
    }
}
