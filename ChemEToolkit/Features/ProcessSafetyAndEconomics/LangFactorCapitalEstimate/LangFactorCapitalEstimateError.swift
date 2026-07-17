import Foundation

enum LangFactorCapitalEstimateError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveEquipmentCost
    case langFactorBelowOne
    case negativeLandCost
    case fractionOutsideRange
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All Lang-factor estimate inputs must be finite."
        case .nonPositiveEquipmentCost:
            return "Purchased equipment cost must be greater than zero."
        case .langFactorBelowOne:
            return "Lang factor must be at least one."
        case .negativeLandCost:
            return "Land cost cannot be negative."
        case .fractionOutsideRange:
            return "Working-capital and startup fractions must lie between zero and one."
        case .numericalFailure:
            return "The Lang-factor capital estimate did not produce finite results."
        }
    }
}
