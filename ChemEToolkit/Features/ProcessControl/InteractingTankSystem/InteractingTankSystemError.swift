import Foundation

enum InteractingTankSystemError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveTankProperty
    case negativeEvaluationTime
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All interacting tank inputs must be finite."
        case .nonPositiveTankProperty:
            return "Tank areas and hydraulic resistances must be greater than zero."
        case .negativeEvaluationTime:
            return "Evaluation time cannot be negative."
        case .numericalFailure:
            return "The interacting tank calculation did not produce finite physical results."
        }
    }
}
