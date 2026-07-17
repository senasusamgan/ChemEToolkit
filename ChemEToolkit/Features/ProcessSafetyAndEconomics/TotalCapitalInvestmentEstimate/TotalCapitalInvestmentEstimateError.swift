import Foundation

enum TotalCapitalInvestmentEstimateError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveEquipmentCost
    case negativeCostComponent
    case fractionOutsideRange
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All total-capital estimate inputs must be finite."
        case .nonPositiveEquipmentCost:
            return "Purchased equipment cost must be greater than zero."
        case .negativeCostComponent:
            return "All additional direct and indirect cost components must be nonnegative."
        case .fractionOutsideRange:
            return "Contingency and working-capital fractions must lie between zero and one."
        case .numericalFailure:
            return "The total-capital estimate did not produce finite results."
        }
    }
}
