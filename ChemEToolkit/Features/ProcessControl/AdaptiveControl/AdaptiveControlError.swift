import Foundation

enum AdaptiveControlError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case negativeAdaptationRate
    case nonPositiveSampleTime
    case invalidGainLimits
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All adaptive-control inputs must be finite."
        case .negativeAdaptationRate:
            return "Adaptation rate cannot be negative."
        case .nonPositiveSampleTime:
            return "Sample time must be greater than zero."
        case .invalidGainLimits:
            return "Minimum controller gain must be less than maximum controller gain."
        case .numericalFailure:
            return "The adaptive-control update did not produce finite results."
        }
    }
}
