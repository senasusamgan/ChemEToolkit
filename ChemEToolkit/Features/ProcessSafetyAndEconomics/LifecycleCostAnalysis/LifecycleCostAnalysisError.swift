import Foundation

enum LifecycleCostAnalysisError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case negativeCost
    case invalidProjectLife
    case invalidReplacementInterval
    case invalidDiscountRate
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All lifecycle-cost inputs must be finite."
        case .negativeCost:
            return "Capital, operating, maintenance, replacement and salvage values cannot be negative."
        case .invalidProjectLife:
            return "Project life must be a whole number from 1 through 100."
        case .invalidReplacementInterval:
            return "Replacement interval must be a whole number from 1 through the project life."
        case .invalidDiscountRate:
            return "Discount rate must be greater than minus one."
        case .numericalFailure:
            return "The lifecycle-cost calculation did not produce finite results."
        }
    }
}
