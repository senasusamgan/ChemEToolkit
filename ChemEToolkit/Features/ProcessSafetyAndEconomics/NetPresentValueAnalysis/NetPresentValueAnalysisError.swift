import Foundation

enum NetPresentValueAnalysisError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveInitialInvestment
    case invalidProjectLife
    case invalidDiscountRate
    case negativeTerminalValue
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All net-present-value inputs must be finite."
        case .nonPositiveInitialInvestment:
            return "Initial investment must be greater than zero."
        case .invalidProjectLife:
            return "Project life must be a whole number from 1 through 100."
        case .invalidDiscountRate:
            return "Discount rate must be greater than minus one."
        case .negativeTerminalValue:
            return "Terminal value cannot be negative."
        case .numericalFailure:
            return "The net-present-value calculation did not produce finite results."
        }
    }
}
