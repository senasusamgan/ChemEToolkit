import Foundation

enum ExpectedMonetaryValueDecisionError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case negativeInitialCost
    case probabilityOutsideRange
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All expected-monetary-value inputs must be finite."
        case .negativeInitialCost:
            return "Initial option costs cannot be negative."
        case .probabilityOutsideRange:
            return "Success probabilities must lie between zero and one."
        case .numericalFailure:
            return "The expected-value calculation did not produce finite results."
        }
    }
}
