import Foundation

enum FilterCakeBalanceError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveFeedFlow
    case invalidFeedSolidsFraction
    case invalidCakeLiquidFraction
    case infeasibleCakeMoisture
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "Slurry flow and composition fractions must be finite."
        case .nonPositiveFeedFlow:
            return "Slurry-feed mass flow must be greater than zero."
        case .invalidFeedSolidsFraction:
            return "Feed dry-solid fraction must satisfy zero through one."
        case .invalidCakeLiquidFraction:
            return "Cake liquid fraction must satisfy zero through less than one."
        case .infeasibleCakeMoisture:
            return "The entered cake liquid fraction requires more retained liquid than is available in the feed."
        case .numericalFailure:
            return "The filter-cake balance did not produce finite results."
        }
    }
}
