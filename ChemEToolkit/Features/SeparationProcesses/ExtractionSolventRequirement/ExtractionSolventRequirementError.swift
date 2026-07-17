import Foundation

enum ExtractionSolventRequirementError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveFeedFlow
    case fractionOutsideRange
    case nonPositiveDistributionCoefficient
    case invalidRemovalFraction
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "Feed, composition, distribution coefficient and target removal must be finite."
        case .nonPositiveFeedFlow:
            return "Feed-carrier flow must be greater than zero."
        case .fractionOutsideRange:
            return "Feed solute fraction must lie between zero and one."
        case .nonPositiveDistributionCoefficient:
            return "The distribution coefficient must be greater than zero."
        case .invalidRemovalFraction:
            return "Target removal must be greater than zero and less than one."
        case .numericalFailure:
            return "The solvent-requirement calculation did not produce finite results."
        }
    }
}
