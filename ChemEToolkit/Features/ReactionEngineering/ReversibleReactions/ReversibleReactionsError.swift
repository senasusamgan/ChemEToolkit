import Foundation

enum ReversibleReactionsError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case negativeInitialConcentration
    case zeroTotalConcentration
    case nonPositiveRateConstant
    case negativeReactionTime
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All reversible-reaction inputs must be finite."
        case .negativeInitialConcentration:
            return "Initial concentrations cannot be negative."
        case .zeroTotalConcentration:
            return "At least one initial concentration must be greater than zero."
        case .nonPositiveRateConstant:
            return "Forward and reverse first-order rate constants must be greater than zero."
        case .negativeReactionTime:
            return "Reaction time cannot be negative."
        case .numericalFailure:
            return "The reversible-reaction calculation did not produce finite physical results."
        }
    }
}
