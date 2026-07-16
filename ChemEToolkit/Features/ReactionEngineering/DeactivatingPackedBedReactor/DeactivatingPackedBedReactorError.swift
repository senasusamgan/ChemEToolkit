import Foundation

enum DeactivatingPackedBedReactorError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveFeedCondition
    case nonPositiveCatalystCondition
    case nonPositiveDeactivationRate
    case negativeTimeOnStream
    case conversionOutOfRange
    case activityUnderflow
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All deactivating packed-bed inputs must be finite."
        case .nonPositiveFeedCondition:
            return "Inlet concentration and volumetric flow rate must be greater than zero."
        case .nonPositiveCatalystCondition:
            return "Catalyst weight and fresh-catalyst rate coefficient must be greater than zero."
        case .nonPositiveDeactivationRate:
            return "First-order deactivation rate constant must be greater than zero."
        case .negativeTimeOnStream:
            return "Time on stream cannot be negative."
        case .conversionOutOfRange:
            return "Target conversion must satisfy 0 < X_target < 1."
        case .activityUnderflow:
            return "Catalyst activity is numerically zero at this time on stream; target-weight sizing is undefined."
        case .numericalFailure:
            return "The deactivating packed-bed calculation did not produce finite physical results."
        }
    }
}
