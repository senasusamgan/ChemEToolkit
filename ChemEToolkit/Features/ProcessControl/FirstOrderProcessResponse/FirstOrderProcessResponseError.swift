import Foundation

enum FirstOrderProcessResponseError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveTimeConstant
    case negativeEvaluationTime
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All first-order process inputs must be finite."
        case .nonPositiveTimeConstant:
            return "Time constant must be greater than zero."
        case .negativeEvaluationTime:
            return "Evaluation time cannot be negative."
        case .numericalFailure:
            return "The first-order response calculation did not produce finite results."
        }
    }
}
