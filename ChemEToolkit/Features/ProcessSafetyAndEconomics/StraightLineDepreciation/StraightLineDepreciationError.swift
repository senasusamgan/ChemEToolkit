import Foundation

enum StraightLineDepreciationError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveAssetCost
    case invalidSalvageValue
    case invalidServiceLife
    case invalidEvaluationAge
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All straight-line depreciation inputs must be finite."
        case .nonPositiveAssetCost:
            return "Depreciable asset cost must be greater than zero."
        case .invalidSalvageValue:
            return "Salvage value must be nonnegative and cannot exceed asset cost."
        case .invalidServiceLife:
            return "Service life must be a whole number from 1 through 100."
        case .invalidEvaluationAge:
            return "Evaluation age must be a whole number from zero through the service life."
        case .numericalFailure:
            return "The depreciation calculation did not produce finite results."
        }
    }
}
