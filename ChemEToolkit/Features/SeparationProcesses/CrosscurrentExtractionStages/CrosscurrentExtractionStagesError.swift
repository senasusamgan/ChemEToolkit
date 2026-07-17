import Foundation

enum CrosscurrentExtractionStagesError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveFlow
    case nonPositiveDistributionCoefficient
    case invalidRemovalFraction
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "Flows, distribution coefficient and target removal must be finite."
        case .nonPositiveFlow:
            return "Feed-carrier flow and solvent per stage must be greater than zero."
        case .nonPositiveDistributionCoefficient:
            return "The distribution coefficient must be greater than zero."
        case .invalidRemovalFraction:
            return "Target removal must be greater than zero and less than one."
        case .numericalFailure:
            return "The crosscurrent-stage calculation did not produce finite results."
        }
    }
}
