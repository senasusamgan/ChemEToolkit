import Foundation

enum AdsorptionIsothermsError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case negativeConcentration
    case nonPositiveParameter
    case invalidFreundlichExponent
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All inputs must be finite."

        case .negativeConcentration:
            return "Equilibrium fluid concentration cannot be negative."

        case .nonPositiveParameter:
            return """
            The parameters used by the selected adsorption model \
            must be greater than zero.
            """

        case .invalidFreundlichExponent:
            return """
            Freundlich exponent n must be greater than one for the \
            implemented favorable-isotherm form q = KF C^(1/n).
            """

        case .numericalFailure:
            return "The adsorption-isotherm calculation did not produce a finite result."
        }
    }
}
