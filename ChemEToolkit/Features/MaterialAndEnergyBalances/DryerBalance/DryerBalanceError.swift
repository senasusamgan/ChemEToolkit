import Foundation

enum DryerBalanceError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveFeedFlow
    case invalidMoistureFraction
    case invalidDryingTarget
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "Feed flow and moisture fractions must be finite."
        case .nonPositiveFeedFlow:
            return "Wet-feed mass flow must be greater than zero."
        case .invalidMoistureFraction:
            return "Wet-basis moisture fractions must satisfy zero through less than one."
        case .invalidDryingTarget:
            return "Target moisture must be lower than or equal to the initial moisture."
        case .numericalFailure:
            return "The dryer balance did not produce finite results."
        }
    }
}
