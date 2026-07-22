import Foundation

enum ReactionPerformanceBalanceError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveReactantFeed
    case negativeAmount
    case outletExceedsFeed
    case productExceedsReactantConsumption
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "Reactant and product amounts must be finite."
        case .nonPositiveReactantFeed:
            return "Reactant-feed amount must be greater than zero."
        case .negativeAmount:
            return "Outlet reactant and product amounts cannot be negative."
        case .outletExceedsFeed:
            return "Reactant outlet amount cannot exceed reactant feed amount."
        case .productExceedsReactantConsumption:
            return "Desired plus undesired product amount cannot exceed reactant consumed on the selected one-to-one basis."
        case .numericalFailure:
            return "The conversion–yield–selectivity calculation did not produce finite results."
        }
    }
}
