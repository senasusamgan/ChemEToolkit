import Foundation

enum EvaporativeCrystallizerBalanceError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveFeedFlow
    case invalidFraction
    case invalidEvaporationFlow
    case infeasibleBalance
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "Flows, compositions and purity must be finite."
        case .nonPositiveFeedFlow:
            return "Feed mass flow must be greater than zero."
        case .invalidFraction:
            return "Feed, mother-liquor and crystal-purity fractions must lie in the physical range."
        case .invalidEvaporationFlow:
            return "Evaporation flow must be nonnegative and lower than feed flow."
        case .infeasibleBalance:
            return "The selected inputs do not produce nonnegative crystal and mother-liquor flows."
        case .numericalFailure:
            return "The evaporative-crystallizer balance did not produce finite results."
        }
    }
}
