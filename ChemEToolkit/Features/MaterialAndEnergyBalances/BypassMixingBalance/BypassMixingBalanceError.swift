import Foundation

enum BypassMixingBalanceError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveFeedFlow
    case fractionOutsideRange
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "Feed, bypass and composition inputs must be finite."
        case .nonPositiveFeedFlow:
            return "Feed mass flow must be greater than zero."
        case .fractionOutsideRange:
            return "Bypass and component fractions must lie between zero and one."
        case .numericalFailure:
            return "The bypass-mixing calculation did not produce finite results."
        }
    }
}
