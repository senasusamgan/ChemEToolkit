import Foundation

enum LayerOfProtectionAnalysisError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveInitiatingFrequency
    case probabilityOutsideRange
    case nonPositiveTolerableFrequency
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All LOPA inputs must be finite."
        case .nonPositiveInitiatingFrequency:
            return "Initiating-event frequency must be greater than zero."
        case .probabilityOutsideRange:
            return "Enabling, conditional and active protection-layer probabilities must satisfy 0 < value ≤ 1."
        case .nonPositiveTolerableFrequency:
            return "Tolerable event frequency must be greater than zero."
        case .numericalFailure:
            return "The LOPA screening calculation did not produce finite results."
        }
    }
}
