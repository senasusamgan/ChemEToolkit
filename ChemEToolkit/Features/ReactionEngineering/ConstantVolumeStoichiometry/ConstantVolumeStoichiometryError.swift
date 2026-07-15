import Foundation

enum ConstantVolumeStoichiometryError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveInitialReactant
    case negativeInitialProduct
    case nonPositiveStoichiometricCoefficient
    case conversionOutOfRange
    case conversionExceedsReactantAvailability
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All constant-volume stoichiometry inputs must be finite."
        case .nonPositiveInitialReactant:
            return "Initial reactant concentrations must be greater than zero."
        case .negativeInitialProduct:
            return "Initial product concentration cannot be negative."
        case .nonPositiveStoichiometricCoefficient:
            return "All stoichiometric coefficients must be greater than zero."
        case .conversionOutOfRange:
            return "Conversion of A must satisfy 0 ≤ X_A ≤ 1."
        case .conversionExceedsReactantAvailability:
            return "Requested conversion exceeds the amount allowed by reactant B."
        case .numericalFailure:
            return "The constant-volume stoichiometry calculation did not produce finite physical results."
        }
    }
}
