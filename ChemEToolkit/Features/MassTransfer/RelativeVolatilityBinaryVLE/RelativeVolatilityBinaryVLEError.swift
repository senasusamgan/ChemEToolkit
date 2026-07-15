import Foundation

enum RelativeVolatilityBinaryVLEError: Error, Equatable, LocalizedError {
    case nonFiniteInput
    case relativeVolatilityNotGreaterThanOne
    case moleFractionOutOfRange
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All inputs must be finite."
        case .relativeVolatilityNotGreaterThanOne:
            return "Relative volatility must be greater than one because the selected component is defined as the more volatile component."
        case .moleFractionOutOfRange:
            return "The specified mole fraction must lie between zero and one."
        case .numericalFailure:
            return "The equilibrium calculation did not produce a finite physical composition."
        }
    }
}
