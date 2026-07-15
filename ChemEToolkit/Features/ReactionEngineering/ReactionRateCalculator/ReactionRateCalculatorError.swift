import Foundation

enum ReactionRateCalculatorError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveRateConstant
    case nonPositiveConcentration
    case nonPositiveStoichiometricCoefficient
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All reaction-rate inputs must be finite."
        case .nonPositiveRateConstant:
            return "Rate constant must be greater than zero."
        case .nonPositiveConcentration:
            return "Reactant concentrations must be greater than zero."
        case .nonPositiveStoichiometricCoefficient:
            return "Stoichiometric coefficients must be greater than zero."
        case .numericalFailure:
            return "The reaction-rate calculation did not produce finite physical results."
        }
    }
}
