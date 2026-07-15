import Foundation

enum CountercurrentLiquidLiquidExtractionError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveProperty
    case negativeSoluteRatio
    case invalidTargetRatio
    case noInitialExtractionDrivingForce
    case infeasibleTargetForExtractionFactor
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
            return "Feed, target and entering-solvent solute ratios cannot be negative."

        case .invalidTargetRatio:
            return """
            Target raffinate ratio must be lower than the feed ratio \
            and above the raffinate composition in equilibrium with the entering solvent.
            """

        case .noInitialExtractionDrivingForce:
            return """
            The entering solvent does not provide a positive extraction \
            driving force for the feed raffinate.
            """

        case .infeasibleTargetForExtractionFactor:
            return """
            For an extraction factor below one, the target reaches or \
            exceeds the infinite-stage limiting removal.
            """

        case .numericalFailure:
            return "The countercurrent extraction stage calculation did not produce a physical result."
        }
    }
}
