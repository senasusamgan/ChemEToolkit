import Foundation

enum BinaryRelativeVolatilityVLEError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case fractionOutsideRange
    case nonPositiveRelativeVolatility
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "Liquid composition and relative volatility must be finite."
        case .fractionOutsideRange:
            return "Liquid mole fraction must lie between zero and one."
        case .nonPositiveRelativeVolatility:
            return "Relative volatility must be greater than zero."
        case .numericalFailure:
            return "The binary VLE calculation did not produce finite results."
        }
    }
}
