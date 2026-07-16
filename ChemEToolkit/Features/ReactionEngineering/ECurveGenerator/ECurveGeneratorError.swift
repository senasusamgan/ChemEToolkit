import Foundation

enum ECurveGeneratorError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case mismatchedArrays
    case insufficientData
    case nonIncreasingTime
    case negativeConcentration
    case zeroTracerArea
    case nonPositiveMeanResidenceTime
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All E-curve time and tracer-concentration values must be finite."
        case .mismatchedArrays:
            return "Time and tracer-concentration arrays must contain the same number of values."
        case .insufficientData:
            return "At least two E-curve measurements are required."
        case .nonIncreasingTime:
            return "E-curve time values must be strictly increasing."
        case .negativeConcentration:
            return "Tracer concentrations cannot be negative."
        case .zeroTracerArea:
            return "Integrated tracer area must be greater than zero."
        case .nonPositiveMeanResidenceTime:
            return "The calculated mean residence time must be greater than zero."
        case .numericalFailure:
            return "The E-curve calculation did not produce finite physical results."
        }
    }
}
