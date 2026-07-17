import Foundation

enum FaultTreeProbabilityError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case probabilityOutsideRange
    case invalidGateCode
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All fault-tree inputs must be finite."
        case .probabilityOutsideRange:
            return "Basic-event probabilities must lie between zero and one."
        case .invalidGateCode:
            return "Gate code must be 1 for OR or 2 for AND."
        case .numericalFailure:
            return "The fault-tree calculation did not produce finite results."
        }
    }
}
