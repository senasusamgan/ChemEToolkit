import Foundation

enum RateLawBuilderError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveStoichiometricCoefficient

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All rate-law builder inputs must be finite."
        case .nonPositiveStoichiometricCoefficient:
            return "Stoichiometric coefficients must be greater than zero."
        }
    }
}
