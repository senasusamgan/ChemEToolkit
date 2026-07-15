import Foundation

enum DistributionCoefficientSelectivityError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveConcentration
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All equilibrium concentrations must be finite."

        case .nonPositiveConcentration:
            return """
            All equilibrium concentrations must be greater than zero \
            so both distribution coefficients and selectivity are defined.
            """

        case .numericalFailure:
            return "The distribution calculation did not produce finite results."
        }
    }
}
