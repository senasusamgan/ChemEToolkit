import Foundation

enum BinaryIsothermalFlashError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveFeedFlow
    case fractionOutsideRange
    case nonPositiveEquilibriumRatio
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "Feed, composition and equilibrium ratios must be finite."
        case .nonPositiveFeedFlow:
            return "Feed molar flow must be greater than zero."
        case .fractionOutsideRange:
            return "Feed mole fraction must lie between zero and one."
        case .nonPositiveEquilibriumRatio:
            return "Both equilibrium ratios must be greater than zero."
        case .numericalFailure:
            return "The flash calculation did not produce finite phase results."
        }
    }
}
