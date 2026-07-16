import Foundation

enum DeadVolumeEstimatorError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveVolumeOrFlow
    case negativeMeanResidenceTime
    case measuredResidenceTimeExceedsNominal
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "Nominal volume, flow rate and measured mean residence time must be finite."
        case .nonPositiveVolumeOrFlow:
            return "Nominal volume and volumetric flow rate must be greater than zero."
        case .negativeMeanResidenceTime:
            return "Measured mean residence time cannot be negative."
        case .measuredResidenceTimeExceedsNominal:
            return "Measured mean residence time exceeds the nominal space time, so a dead-volume-only interpretation is not valid."
        case .numericalFailure:
            return "The dead-volume calculation did not produce finite physical results."
        }
    }
}
