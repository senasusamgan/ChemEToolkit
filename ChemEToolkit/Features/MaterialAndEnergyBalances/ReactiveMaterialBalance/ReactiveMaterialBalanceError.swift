import Foundation

enum ReactiveMaterialBalanceError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case negativeFeedFlow
    case nonPositiveStoichiometricCoefficient
    case fractionOutsideRange
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "Feed, coefficients and conversion must be finite."
        case .negativeFeedFlow:
            return "Reactant-feed molar flow cannot be negative."
        case .nonPositiveStoichiometricCoefficient:
            return "Stoichiometric coefficients must be greater than zero."
        case .fractionOutsideRange:
            return "Reactant conversion must lie between zero and one."
        case .numericalFailure:
            return "The reactive material balance did not produce finite results."
        }
    }
}
