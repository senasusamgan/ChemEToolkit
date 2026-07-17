import Foundation

enum TwoStreamMixerBalanceError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case negativeMassFlow
    case fractionOutsideRange
    case zeroOutletFlow
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "Mass flow rates and mass fractions must be finite."
        case .negativeMassFlow:
            return "Stream mass flow rates cannot be negative."
        case .fractionOutsideRange:
            return "Component mass fractions must lie between zero and one."
        case .zeroOutletFlow:
            return "At least one inlet mass flow must be positive."
        case .numericalFailure:
            return "The mixer-balance calculation did not produce finite results."
        }
    }
}
