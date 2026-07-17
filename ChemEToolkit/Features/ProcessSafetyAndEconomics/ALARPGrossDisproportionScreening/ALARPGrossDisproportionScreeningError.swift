import Foundation

enum ALARPGrossDisproportionScreeningError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case negativeCostOrBenefit
    case invalidProjectLife
    case invalidDiscountRate
    case invalidGrossDisproportionFactor
    case zeroRiskReductionBenefit
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All ALARP screening inputs must be finite."
        case .negativeCostOrBenefit:
            return "Measure cost and annualized loss reduction cannot be negative."
        case .invalidProjectLife:
            return "Project life must be a whole number from 1 through 100."
        case .invalidDiscountRate:
            return "Discount rate must be greater than minus one."
        case .invalidGrossDisproportionFactor:
            return "Gross-disproportion factor must be at least one."
        case .zeroRiskReductionBenefit:
            return "Annualized loss reduction must be greater than zero for this screening."
        case .numericalFailure:
            return "The ALARP screening calculation did not produce finite results."
        }
    }
}
