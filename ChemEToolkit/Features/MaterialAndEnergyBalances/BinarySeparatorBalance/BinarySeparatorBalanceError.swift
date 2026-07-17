import Foundation

enum BinarySeparatorBalanceError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveFeedFlow
    case invalidProductFlow
    case fractionOutsideRange
    case infeasibleComponentBalance
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All separator-balance inputs must be finite."
        case .nonPositiveFeedFlow:
            return "Feed mass flow must be greater than zero."
        case .invalidProductFlow:
            return "Product 1 flow must be nonnegative and smaller than feed flow."
        case .fractionOutsideRange:
            return "Feed and product fractions must lie between zero and one."
        case .infeasibleComponentBalance:
            return "The entered Product 1 conditions require an impossible Product 2 composition."
        case .numericalFailure:
            return "The separator-balance calculation did not produce finite results."
        }
    }
}
