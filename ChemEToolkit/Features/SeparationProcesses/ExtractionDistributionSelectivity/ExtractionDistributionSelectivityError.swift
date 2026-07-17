import Foundation

enum ExtractionDistributionSelectivityError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveFlow
    case nonPositiveDistributionCoefficient
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "Flows and distribution coefficients must be finite."
        case .nonPositiveFlow:
            return "Feed-carrier and solvent-carrier flow rates must be greater than zero."
        case .nonPositiveDistributionCoefficient:
            return "Target and impurity distribution coefficients must be greater than zero."
        case .numericalFailure:
            return "The extraction-selectivity calculation did not produce finite results."
        }
    }
}
