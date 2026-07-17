import Foundation

enum CostIndexEscalationError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveCostOrIndex
    case nonPositiveElapsedYears
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All cost-index escalation inputs must be finite."
        case .nonPositiveCostOrIndex:
            return "Base cost and both cost indices must be greater than zero."
        case .nonPositiveElapsedYears:
            return "Elapsed years must be greater than zero."
        case .numericalFailure:
            return "The cost-index escalation calculation did not produce finite results."
        }
    }
}
