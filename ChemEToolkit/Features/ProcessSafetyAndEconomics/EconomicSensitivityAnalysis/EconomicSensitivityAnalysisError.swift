import Foundation

enum EconomicSensitivityAnalysisError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case negativeBaseFinancialValue
    case nonPositiveCapitalInvestment
    case invalidProjectLife
    case invalidDiscountRate
    case scenarioProducesNegativeRevenueOrCost
    case scenarioProducesNonPositiveCapital
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All economic sensitivity inputs must be finite."
        case .negativeBaseFinancialValue:
            return "Base revenue, operating cost and capital investment cannot be negative."
        case .nonPositiveCapitalInvestment:
            return "Base capital investment must be greater than zero."
        case .invalidProjectLife:
            return "Project life must be a whole number from 1 through 100."
        case .invalidDiscountRate:
            return "Discount rate must be greater than minus one."
        case .scenarioProducesNegativeRevenueOrCost:
            return "Revenue and operating-cost changes cannot produce negative scenario values."
        case .scenarioProducesNonPositiveCapital:
            return "Capital change must leave scenario capital investment greater than zero."
        case .numericalFailure:
            return "The economic sensitivity calculation did not produce finite results."
        }
    }
}
