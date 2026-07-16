import Foundation

enum SegregationModelConversionError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveInitialConcentration
    case nonPositiveRateConstant
    case reactionOrderOutOfRange
    case mismatchedArrays
    case insufficientData
    case negativeTime
    case nonIncreasingTime
    case negativeEValue
    case zeroRTDArea
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All segregation-model inputs must be finite."
        case .nonPositiveInitialConcentration:
            return "Initial reactant concentration must be greater than zero."
        case .nonPositiveRateConstant:
            return "Rate constant must be greater than zero."
        case .reactionOrderOutOfRange:
            return "Reaction order must satisfy 0 ≤ n ≤ 3."
        case .mismatchedArrays:
            return "Time and E(t) arrays must contain the same number of values."
        case .insufficientData:
            return "At least two RTD points are required."
        case .negativeTime:
            return "Residence-time values cannot be negative."
        case .nonIncreasingTime:
            return "Residence-time values must be strictly increasing."
        case .negativeEValue:
            return "E(t) values cannot be negative."
        case .zeroRTDArea:
            return "Integrated E(t) area must be greater than zero."
        case .numericalFailure:
            return "The segregation-model calculation did not produce finite physical results."
        }
    }
}
