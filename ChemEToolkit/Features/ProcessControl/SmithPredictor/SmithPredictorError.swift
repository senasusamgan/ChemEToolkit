import Foundation

enum SmithPredictorError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveTimeConstant
    case negativeDeadTime
    case negativeEvaluationTime
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All Smith-predictor inputs must be finite."
        case .nonPositiveTimeConstant:
            return "Actual and model time constants must be greater than zero."
        case .negativeDeadTime:
            return "Actual and model dead times cannot be negative."
        case .negativeEvaluationTime:
            return "Evaluation time cannot be negative."
        case .numericalFailure:
            return "The Smith-predictor calculation did not produce finite results."
        }
    }
}
