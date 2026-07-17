import Foundation

enum IndividualRiskScreeningError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case negativeScenarioFrequency
    case probabilityOutsideRange
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All individual-risk inputs must be finite."
        case .negativeScenarioFrequency:
            return "Scenario frequency cannot be negative."
        case .probabilityOutsideRange:
            return "Conditional fatality, occupancy and presence probabilities must lie between zero and one."
        case .numericalFailure:
            return "The individual-risk calculation did not produce finite results."
        }
    }
}
