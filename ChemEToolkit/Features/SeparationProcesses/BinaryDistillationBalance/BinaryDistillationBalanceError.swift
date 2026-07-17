import Foundation

enum BinaryDistillationBalanceError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveFeedFlow
    case fractionOutsideRange
    case invalidSeparationOrdering
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "Feed, flow and product compositions must be finite."
        case .nonPositiveFeedFlow:
            return "Feed molar flow must be greater than zero."
        case .fractionOutsideRange:
            return "All compositions must lie between zero and one."
        case .invalidSeparationOrdering:
            return "Distillate composition must exceed feed composition, which must exceed bottoms composition."
        case .numericalFailure:
            return "The distillation balance did not produce finite results."
        }
    }
}
