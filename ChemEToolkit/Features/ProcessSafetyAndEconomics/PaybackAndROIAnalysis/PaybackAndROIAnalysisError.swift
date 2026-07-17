import Foundation

enum PaybackAndROIAnalysisError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveInitialInvestment
    case negativeFinancialInput
    case invalidTaxRate
    case invalidSalvageValue
    case invalidProjectLife
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All payback and ROI inputs must be finite."
        case .nonPositiveInitialInvestment:
            return "Initial investment must be greater than zero."
        case .negativeFinancialInput:
            return "Revenue, cash operating cost, depreciation and salvage value cannot be negative."
        case .invalidTaxRate:
            return "Income-tax rate must lie between zero and one."
        case .invalidSalvageValue:
            return "Salvage value cannot exceed the initial investment."
        case .invalidProjectLife:
            return "Project life must be a whole number from 1 through 100."
        case .numericalFailure:
            return "The payback and ROI calculation did not produce finite results."
        }
    }
}
