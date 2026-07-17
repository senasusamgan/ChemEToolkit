import Foundation

enum WeightedAveragePropertyError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case negativeFraction
    case zeroFractionSum
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "Fractions and property values must be finite."
        case .negativeFraction:
            return "Fractions cannot be negative."
        case .zeroFractionSum:
            return "At least one fraction must be positive."
        case .numericalFailure:
            return "The weighted-average calculation did not produce finite results."
        }
    }
}
