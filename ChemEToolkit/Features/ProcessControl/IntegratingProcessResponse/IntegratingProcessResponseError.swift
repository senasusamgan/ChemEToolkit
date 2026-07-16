import Foundation

enum IntegratingProcessResponseError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case negativeDeadTime
    case negativeEvaluationTime
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All integrating-process inputs must be finite."
        case .negativeDeadTime:
            return "Dead time cannot be negative."
        case .negativeEvaluationTime:
            return "Evaluation time cannot be negative."
        case .numericalFailure:
            return "The integrating-process calculation did not produce finite results."
        }
    }
}
