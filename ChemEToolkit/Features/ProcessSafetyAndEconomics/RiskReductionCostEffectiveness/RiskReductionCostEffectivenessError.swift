import Foundation

enum RiskReductionCostEffectivenessError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case negativeFinancialValue
    case residualExceedsCurrentLoss
    case invalidProjectLife
    case invalidDiscountRate
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All risk-reduction economic inputs must be finite."
        case .negativeFinancialValue:
            return "Annualized losses, investment and maintenance cost cannot be negative."
        case .residualExceedsCurrentLoss:
            return "Residual annualized loss cannot exceed current annualized loss."
        case .invalidProjectLife:
            return "Project life must be a whole number from 1 through 100."
        case .invalidDiscountRate:
            return "Discount rate must be greater than minus one."
        case .numericalFailure:
            return "The cost-effectiveness calculation did not produce finite results."
        }
    }
}
