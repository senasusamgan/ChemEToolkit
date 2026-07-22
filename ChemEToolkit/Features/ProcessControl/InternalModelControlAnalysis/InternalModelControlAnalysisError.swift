import Foundation

enum InternalModelControlAnalysisError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case zeroProcessGain
    case nonPositiveTimeConstant
    case negativeDeadTime
    case negativeAngularFrequency
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All Internal Model Control inputs must be finite."
        case .zeroProcessGain:
            return "Actual and model process gains cannot be zero."
        case .nonPositiveTimeConstant:
            return "Actual, model and filter time constants must be greater than zero."
        case .negativeDeadTime:
            return "Model dead time cannot be negative."
        case .negativeAngularFrequency:
            return "Angular frequency cannot be negative."
        case .numericalFailure:
            return "The Internal Model Control calculation did not produce finite results."
        }
    }
}
