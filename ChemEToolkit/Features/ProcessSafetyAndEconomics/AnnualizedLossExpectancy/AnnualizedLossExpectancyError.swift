import Foundation

enum AnnualizedLossExpectancyError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case negativeFrequency
    case negativeCost
    case insuranceFractionOutsideRange
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All annualized-loss inputs must be finite."
        case .negativeFrequency:
            return "Event frequency cannot be negative."
        case .negativeCost:
            return "Loss components cannot be negative."
        case .insuranceFractionOutsideRange:
            return "Insurance recovery fraction must lie between zero and one."
        case .numericalFailure:
            return "The annualized-loss calculation did not produce finite results."
        }
    }
}
