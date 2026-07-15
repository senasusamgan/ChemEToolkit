import Foundation

enum ParallelReactionsError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveInitialConcentration
    case nonPositiveDesiredRateConstant
    case negativeUndesiredRateConstant
    case negativeReactionTime
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All parallel-reaction inputs must be finite."
        case .nonPositiveInitialConcentration:
            return "Initial reactant concentration must be greater than zero."
        case .nonPositiveDesiredRateConstant:
            return "Desired-path rate constant must be greater than zero."
        case .negativeUndesiredRateConstant:
            return "Undesired-path rate constant cannot be negative."
        case .negativeReactionTime:
            return "Reaction time cannot be negative."
        case .numericalFailure:
            return "The parallel-reaction calculation did not produce finite physical results."
        }
    }
}
