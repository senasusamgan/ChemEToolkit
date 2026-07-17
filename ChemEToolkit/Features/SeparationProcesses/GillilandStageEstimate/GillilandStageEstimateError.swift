import Foundation

enum GillilandStageEstimateError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveMinimumStages
    case negativeMinimumReflux
    case operatingRefluxNotAboveMinimum
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "Stage and reflux inputs must be finite."
        case .nonPositiveMinimumStages:
            return "Minimum theoretical stages must be greater than zero."
        case .negativeMinimumReflux:
            return "Minimum reflux ratio cannot be negative."
        case .operatingRefluxNotAboveMinimum:
            return "Operating reflux ratio must exceed minimum reflux ratio."
        case .numericalFailure:
            return "The Gilliland estimate did not produce finite stages."
        }
    }
}
