import Foundation

enum SeriesParallelReactionsError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveInitialConcentration
    case nonPositiveRateConstant
    case negativeReactionTime
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All series–parallel reaction inputs must be finite."
        case .nonPositiveInitialConcentration:
            return "Initial concentration of A must be greater than zero."
        case .nonPositiveRateConstant:
            return "All first-order rate constants must be greater than zero."
        case .negativeReactionTime:
            return "Reaction time cannot be negative."
        case .numericalFailure:
            return "The series–parallel calculation did not produce finite physical results."
        }
    }
}
