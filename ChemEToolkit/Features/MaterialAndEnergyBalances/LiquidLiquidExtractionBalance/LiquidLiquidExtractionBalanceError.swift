import Foundation

enum LiquidLiquidExtractionBalanceError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveFeedMass
    case invalidFeedFraction
    case negativeSolventMass
    case negativeDistributionCoefficient
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "Feed, solvent, composition and distribution inputs must be finite."
        case .nonPositiveFeedMass:
            return "Feed-solution mass must be greater than zero."
        case .invalidFeedFraction:
            return "Feed solute fraction must satisfy zero through less than one."
        case .negativeSolventMass:
            return "Pure-solvent mass cannot be negative."
        case .negativeDistributionCoefficient:
            return "Distribution coefficient cannot be negative."
        case .numericalFailure:
            return "The extraction balance did not produce finite results."
        }
    }
}
