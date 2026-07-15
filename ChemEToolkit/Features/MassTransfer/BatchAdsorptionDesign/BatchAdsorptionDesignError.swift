import Foundation

enum BatchAdsorptionDesignError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveSolutionVolume
    case invalidConcentrationOrdering
    case nonPositiveModelParameter
    case invalidFreundlichExponent
    case zeroEquilibriumLoading
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All batch-adsorption inputs must be finite."

        case .nonPositiveSolutionVolume:
            return "Solution volume must be greater than zero."

        case .invalidConcentrationOrdering:
            return """
            Initial concentration must be greater than zero, and the \
            target equilibrium concentration must satisfy 0 ≤ Ce < C0.
            """

        case .nonPositiveModelParameter:
            return """
            The parameters used by the selected adsorption model \
            must be greater than zero.
            """

        case .invalidFreundlichExponent:
            return """
            Freundlich exponent n must be greater than one for the \
            implemented favorable-isotherm form.
            """

        case .zeroEquilibriumLoading:
            return """
            The selected target concentration gives zero equilibrium \
            loading, so a finite adsorbent requirement cannot be calculated.
            """

        case .numericalFailure:
            return "The batch-adsorption design did not produce finite physical results."
        }
    }
}
