import Foundation

enum EvaporatorBalanceError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveFeedFlow
    case fractionOutsideRange
    case invalidProductConcentration
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "Feed flow and solute fractions must be finite."
        case .nonPositiveFeedFlow:
            return "Feed mass flow must be greater than zero."
        case .fractionOutsideRange:
            return "Feed and product solute fractions must lie between zero and one."
        case .invalidProductConcentration:
            return "Product solute fraction must be positive and at least as large as the feed fraction."
        case .numericalFailure:
            return "The evaporator balance did not produce finite results."
        }
    }
}
