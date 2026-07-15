import Foundation

enum BinaryFlashCalculationError: Error, Equatable, LocalizedError {
    case nonFiniteInput
    case nonPositiveFeedFlow
    case feedCompositionOutOfRange
    case nonPositiveKValue
    case invalidKValueOrdering
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput: return "All inputs must be finite."
        case .nonPositiveFeedFlow: return "Feed flow rate must be greater than zero."
        case .feedCompositionOutOfRange: return "Feed light-component mole fraction must lie between zero and one."
        case .nonPositiveKValue: return "Both equilibrium K-values must be greater than zero."
        case .invalidKValueOrdering: return "The light-component K-value must be greater than the heavy-component K-value."
        case .numericalFailure: return "The flash calculation did not converge to a physical result."
        }
    }
}
