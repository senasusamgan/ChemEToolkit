import Foundation

enum BreakEvenProductionAnalysisError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case negativeFixedCost
    case nonPositiveSellingPrice
    case invalidContributionMargin
    case negativeExpectedProduction
    case nonPositiveMaximumCapacity
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All break-even analysis inputs must be finite."
        case .negativeFixedCost:
            return "Annual fixed cost cannot be negative."
        case .nonPositiveSellingPrice:
            return "Selling price per unit must be greater than zero."
        case .invalidContributionMargin:
            return "Selling price must exceed variable cost per unit."
        case .negativeExpectedProduction:
            return "Expected annual production cannot be negative."
        case .nonPositiveMaximumCapacity:
            return "Maximum annual capacity must be greater than zero."
        case .numericalFailure:
            return "The break-even calculation did not produce finite results."
        }
    }
}
