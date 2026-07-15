import Foundation

enum ConstantPressureFiltrationError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveProperty
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All filtration inputs must be finite."

        case .nonPositiveProperty:
            return """
            Viscosity, pressure drop, filter area, specific cake resistance, \
            slurry solids concentration, medium resistance and target \
            filtrate volume must be greater than zero.
            """

        case .numericalFailure:
            return "The constant-pressure filtration calculation did not produce finite physical results."
        }
    }
}
