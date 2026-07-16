import Foundation

enum RTDModelComparisonError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveMeanResidenceTime
    case nonPositiveVariance
    case varianceOutsideTanksModelRange
    case nonPositiveRateConstant
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All RTD model-comparison inputs must be finite."
        case .nonPositiveMeanResidenceTime:
            return "Mean residence time must be greater than zero."
        case .nonPositiveVariance:
            return "Residence-time variance must be greater than zero."
        case .varianceOutsideTanksModelRange:
            return "For this tanks-in-series comparison, variance must not exceed the square of the mean residence time."
        case .nonPositiveRateConstant:
            return "First-order rate constant must be greater than zero."
        case .numericalFailure:
            return "The RTD model comparison did not produce finite physical results."
        }
    }
}
