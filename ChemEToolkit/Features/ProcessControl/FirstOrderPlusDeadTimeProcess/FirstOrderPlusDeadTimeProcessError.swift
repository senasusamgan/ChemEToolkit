import Foundation

enum FirstOrderPlusDeadTimeProcessError:
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
            return "All FOPDT process inputs must be finite."
        case .nonPositiveTimeConstant:
            return "Time constant must be greater than zero."
        case .negativeDeadTime:
            return "Process dead time cannot be negative."
        case .negativeEvaluationTime:
            return "Evaluation time cannot be negative."
        case .numericalFailure:
            return "The FOPDT response calculation did not produce finite results."
        }
    }
}
