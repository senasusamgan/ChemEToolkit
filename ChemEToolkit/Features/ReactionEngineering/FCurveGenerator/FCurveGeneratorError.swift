import Foundation

enum FCurveGeneratorError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case mismatchedArrays
    case insufficientData
    case nonIncreasingTime
    case negativeEValue
    case zeroEArea
    case quantileNotResolved
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All F-curve time and E(t) values must be finite."
        case .mismatchedArrays:
            return "Time and E(t) arrays must contain the same number of values."
        case .insufficientData:
            return "At least two F-curve measurements are required."
        case .nonIncreasingTime:
            return "F-curve time values must be strictly increasing."
        case .negativeEValue:
            return "E(t) values cannot be negative."
        case .zeroEArea:
            return "Integrated E(t) area must be greater than zero."
        case .quantileNotResolved:
            return "The supplied RTD data do not resolve all required cumulative quantiles."
        case .numericalFailure:
            return "The F-curve calculation did not produce finite physical results."
        }
    }
}
