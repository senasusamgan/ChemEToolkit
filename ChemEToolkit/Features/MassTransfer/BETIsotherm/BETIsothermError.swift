import Foundation

enum BETIsothermError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case relativePressureOutOfRange
    case nonPositiveModelParameter
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All BET-isotherm inputs must be finite."

        case .relativePressureOutOfRange:
            return "Relative pressure must satisfy 0 < p/p₀ < 1."

        case .nonPositiveModelParameter:
            return """
            Monolayer capacity, BET constant, adsorbate molar mass and \
            molecular cross-sectional area must be greater than zero.
            """

        case .numericalFailure:
            return "The BET-isotherm calculation did not produce finite physical results."
        }
    }
}
