import Foundation

enum RecyclePFRError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveFeed
    case nonPositiveVolumeOrRateConstant
    case negativeRecycleRatio
    case recycleRatioTooLarge
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All recycle-PFR inputs must be finite."
        case .nonPositiveFeed:
            return "Fresh-feed concentration and volumetric flow rate must be greater than zero."
        case .nonPositiveVolumeOrRateConstant:
            return "Reactor volume and first-order rate constant must be greater than zero."
        case .negativeRecycleRatio:
            return "Recycle ratio cannot be negative."
        case .recycleRatioTooLarge:
            return "Recycle ratio must not exceed 1000 in this calculator."
        case .numericalFailure:
            return "The recycle-PFR calculation did not produce finite physical results."
        }
    }
}
