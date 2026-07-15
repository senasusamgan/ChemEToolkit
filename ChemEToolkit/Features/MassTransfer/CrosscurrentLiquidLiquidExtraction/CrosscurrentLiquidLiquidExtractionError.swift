import Foundation

enum CrosscurrentLiquidLiquidExtractionError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveProperty
    case negativeSoluteRatio
    case invalidStageCount
    case reverseTransferAtFeed
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All inputs must be finite."

        case .nonPositiveProperty:
            return """
            Raffinate carrier flow, total solvent flow and \
            distribution coefficient must be greater than zero.
            """

        case .negativeSoluteRatio:
            return "Feed and fresh-solvent solute ratios cannot be negative."

        case .invalidStageCount:
            return "Number of stages must be a whole number from 1 through 100."

        case .reverseTransferAtFeed:
            return """
            The fresh solvent is too solute-rich for extraction from \
            the entering raffinate on the selected equilibrium basis.
            """

        case .numericalFailure:
            return "The crosscurrent extraction calculation did not produce finite results."
        }
    }
}
