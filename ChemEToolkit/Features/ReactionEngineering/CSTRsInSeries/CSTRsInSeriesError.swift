import Foundation

enum CSTRsInSeriesError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveRateConstant
    case nonPositiveVolumeOrFlow
    case invalidReactorCount
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All CSTR-series inputs must be finite."
        case .nonPositiveRateConstant:
            return "First-order rate constant must be greater than zero."
        case .nonPositiveVolumeOrFlow:
            return "Total reactor volume and volumetric flow rate must be greater than zero."
        case .invalidReactorCount:
            return "Number of reactors must be a whole number from 1 through 100."
        case .numericalFailure:
            return "The CSTR-series calculation did not produce finite physical results."
        }
    }
}
