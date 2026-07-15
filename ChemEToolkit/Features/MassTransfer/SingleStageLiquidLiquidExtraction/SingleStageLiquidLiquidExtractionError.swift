import Foundation

enum SingleStageLiquidLiquidExtractionError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveProperty
    case negativeSoluteRatio
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All inputs must be finite."

        case .nonPositiveProperty:
            return """
            Raffinate carrier flow, solvent carrier flow and \
            distribution coefficient must be greater than zero.
            """

        case .negativeSoluteRatio:
            return "Feed and entering-solvent solute ratios cannot be negative."

        case .numericalFailure:
            return "The single-stage extraction calculation did not produce a physical result."
        }
    }
}
