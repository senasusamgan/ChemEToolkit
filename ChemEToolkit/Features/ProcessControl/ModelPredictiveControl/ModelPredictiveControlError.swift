import Foundation

enum ModelPredictiveControlError: Error, Equatable, LocalizedError {
    case nonFiniteInput
    case nonPositiveTimeParameter
    case invalidPredictionHorizon
    case negativeMoveSuppression
    case invalidInputLimits
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All Model Predictive Control inputs must be finite."
        case .nonPositiveTimeParameter:
            return "Process time constant and sample time must be greater than zero."
        case .invalidPredictionHorizon:
            return "Prediction horizon must be a whole number from 1 through 100."
        case .negativeMoveSuppression:
            return "Move-suppression weight cannot be negative."
        case .invalidInputLimits:
            return "Minimum manipulated input must be less than maximum manipulated input."
        case .numericalFailure:
            return "The Model Predictive Control calculation did not produce finite results."
        }
    }
}
