import Foundation

enum ReactionOrderDeterminationError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveConcentrationOrRate
    case equalConcentrations
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All initial-rate inputs must be finite."
        case .nonPositiveConcentrationOrRate:
            return "Concentrations and measured rates must be greater than zero."
        case .equalConcentrations:
            return "The two experiments must use different concentrations."
        case .numericalFailure:
            return "The reaction-order calculation did not produce finite physical results."
        }
    }
}
