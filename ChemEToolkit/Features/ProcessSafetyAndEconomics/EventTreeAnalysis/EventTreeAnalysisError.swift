import Foundation

enum EventTreeAnalysisError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveInitiatingFrequency
    case probabilityOutsideRange
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All event-tree inputs must be finite."
        case .nonPositiveInitiatingFrequency:
            return "Initiating-event frequency must be greater than zero."
        case .probabilityOutsideRange:
            return "Barrier success probabilities must lie between zero and one."
        case .numericalFailure:
            return "The event-tree calculation did not produce finite results."
        }
    }
}
