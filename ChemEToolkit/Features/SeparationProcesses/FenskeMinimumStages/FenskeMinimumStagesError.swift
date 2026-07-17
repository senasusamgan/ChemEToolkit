import Foundation

enum FenskeMinimumStagesError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case fractionAtBoundary
    case invalidSeparationOrdering
    case invalidRelativeVolatility
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "Product compositions and relative volatility must be finite."
        case .fractionAtBoundary:
            return "Product mole fractions must be strictly between zero and one."
        case .invalidSeparationOrdering:
            return "Distillate light-component fraction must exceed bottoms light-component fraction."
        case .invalidRelativeVolatility:
            return "Average relative volatility must exceed one."
        case .numericalFailure:
            return "The Fenske calculation did not produce finite positive stages."
        }
    }
}
