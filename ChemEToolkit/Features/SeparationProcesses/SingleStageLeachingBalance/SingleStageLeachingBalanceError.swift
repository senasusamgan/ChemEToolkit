import Foundation

enum SingleStageLeachingBalanceError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveMass
    case invalidLoadingOrCoefficient
    case invalidRetention
    case retentionExceedsSolvent
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "Masses, loading, coefficient and retention must be finite."
        case .nonPositiveMass:
            return "Dry-solid and solvent masses must be greater than zero."
        case .invalidLoadingOrCoefficient:
            return "Initial solute loading and distribution coefficient must be greater than zero."
        case .invalidRetention:
            return "Solution retention per dry solid cannot be negative."
        case .retentionExceedsSolvent:
            return "Retained solution cannot exceed the total solvent mass."
        case .numericalFailure:
            return "The leaching calculation did not produce finite results."
        }
    }
}
