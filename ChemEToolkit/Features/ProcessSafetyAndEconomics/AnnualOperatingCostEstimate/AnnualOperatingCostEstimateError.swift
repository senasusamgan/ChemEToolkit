import Foundation

enum AnnualOperatingCostEstimateError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case negativeCostComponent
    case fractionOutsideRange
    case nonPositiveAnnualProduction
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All annual operating-cost inputs must be finite."
        case .negativeCostComponent:
            return "Annual cost components and fixed capital investment cannot be negative."
        case .fractionOutsideRange:
            return "Overhead and insurance/tax fractions must lie between zero and one."
        case .nonPositiveAnnualProduction:
            return "Annual production must be greater than zero."
        case .numericalFailure:
            return "The annual operating-cost calculation did not produce finite results."
        }
    }
}
