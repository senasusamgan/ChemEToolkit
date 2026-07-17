import Foundation

enum RecyclePurgeInertBalanceError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveFreshFeed
    case fractionOutsideRange
    case invalidPurgeFraction
    case singularRecycleSystem
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "Fresh-feed, conversion and purge inputs must be finite."
        case .nonPositiveFreshFeed:
            return "Fresh-feed mass flow must be greater than zero."
        case .fractionOutsideRange:
            return "Fresh-feed inert fraction and conversion must lie between zero and one."
        case .invalidPurgeFraction:
            return "Purge fraction must be greater than zero and less than or equal to one."
        case .singularRecycleSystem:
            return "The selected conversion and purge combination creates an unbounded recycle flow."
        case .numericalFailure:
            return "The recycle–purge calculation did not produce finite results."
        }
    }
}
