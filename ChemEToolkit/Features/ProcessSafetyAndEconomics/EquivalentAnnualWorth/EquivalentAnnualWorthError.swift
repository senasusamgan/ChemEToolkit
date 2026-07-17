import Foundation

enum EquivalentAnnualWorthError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveInitialInvestment
    case negativeTerminalValue
    case invalidProjectLife
    case invalidDiscountRate
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All equivalent annual-worth inputs must be finite."
        case .nonPositiveInitialInvestment:
            return "Initial investment must be greater than zero."
        case .negativeTerminalValue:
            return "Terminal value cannot be negative."
        case .invalidProjectLife:
            return "Project life must be a whole number from 1 through 100."
        case .invalidDiscountRate:
            return "Discount rate must be greater than minus one."
        case .numericalFailure:
            return "The equivalent annual-worth calculation did not produce finite results."
        }
    }
}
