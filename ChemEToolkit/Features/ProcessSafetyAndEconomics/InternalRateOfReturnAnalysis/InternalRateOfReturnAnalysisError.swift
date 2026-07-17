import Foundation

enum InternalRateOfReturnAnalysisError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveInitialInvestment
    case invalidProjectLife
    case negativeTerminalValue
    case invalidSearchRange
    case rootNotBracketed
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All Internal Rate of Return inputs must be finite."
        case .nonPositiveInitialInvestment:
            return "Initial investment must be greater than zero."
        case .invalidProjectLife:
            return "Project life must be a whole number from 1 through 100."
        case .negativeTerminalValue:
            return "Terminal value cannot be negative."
        case .invalidSearchRange:
            return "Search rates must satisfy −1 < minimum rate < maximum rate."
        case .rootNotBracketed:
            return "The selected search interval does not bracket an IRR root."
        case .numericalFailure:
            return "The IRR calculation did not converge to a finite result."
        }
    }
}
