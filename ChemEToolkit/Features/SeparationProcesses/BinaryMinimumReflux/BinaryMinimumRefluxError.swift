import Foundation

enum BinaryMinimumRefluxError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case fractionAtBoundary
    case invalidCompositionOrdering
    case invalidRelativeVolatility
    case infeasiblePinch
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "Feed, distillate and relative-volatility inputs must be finite."
        case .fractionAtBoundary:
            return "Feed and distillate fractions must be strictly between zero and one."
        case .invalidCompositionOrdering:
            return "Distillate composition must exceed feed composition."
        case .invalidRelativeVolatility:
            return "Relative volatility must exceed one."
        case .infeasiblePinch:
            return "The saturated-liquid feed pinch does not yield a positive finite minimum reflux ratio."
        case .numericalFailure:
            return "The minimum-reflux calculation did not produce finite results."
        }
    }
}
