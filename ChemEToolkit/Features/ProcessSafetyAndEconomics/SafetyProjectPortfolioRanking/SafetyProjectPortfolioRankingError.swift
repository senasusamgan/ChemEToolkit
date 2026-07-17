import Foundation

enum SafetyProjectPortfolioRankingError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case negativeRiskReduction
    case nonPositiveProjectCost
    case urgencyOutsideRange
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All safety-project ranking inputs must be finite."
        case .negativeRiskReduction:
            return "Estimated risk reduction cannot be negative."
        case .nonPositiveProjectCost:
            return "Each project cost must be greater than zero."
        case .urgencyOutsideRange:
            return "Urgency ratings must lie from one through five."
        case .numericalFailure:
            return "The safety-project ranking calculation did not produce finite results."
        }
    }
}
