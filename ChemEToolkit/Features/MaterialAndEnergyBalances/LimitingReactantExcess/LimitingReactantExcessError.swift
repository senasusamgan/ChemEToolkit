import Foundation

enum LimitingReactantExcessError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case negativeReactantAmount
    case nonPositiveStoichiometricCoefficient
    case zeroTotalReactant
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "Reactant amounts and stoichiometric coefficients must be finite."
        case .negativeReactantAmount:
            return "Reactant amounts cannot be negative."
        case .nonPositiveStoichiometricCoefficient:
            return "Stoichiometric coefficients must be greater than zero."
        case .zeroTotalReactant:
            return "At least one reactant amount must be positive."
        case .numericalFailure:
            return "The limiting-reactant calculation did not produce finite results."
        }
    }
}
