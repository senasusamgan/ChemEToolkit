import Foundation

enum CrystallizationYieldMotherLiquorError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveFeedMass
    case feedCompositionOutOfRange
    case negativeEvaporation
    case evaporationRemovesAllSolvent
    case nonPositiveSolubility
    case crystalCompositionOutOfRange
    case incompatibleCrystalComposition
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All crystallization inputs must be finite."

        case .nonPositiveFeedMass:
            return "Feed solution mass must be greater than zero."

        case .feedCompositionOutOfRange:
            return "Feed solute mass fraction must lie strictly between zero and one."

        case .negativeEvaporation:
            return "Evaporated solvent mass cannot be negative."

        case .evaporationRemovesAllSolvent:
            return """
            Evaporated solvent must be lower than the solvent initially \
            present in the feed solution.
            """

        case .nonPositiveSolubility:
            return "Final solubility ratio must be greater than zero."

        case .crystalCompositionOutOfRange:
            return "Crystal solute mass fraction must satisfy 0 < p ≤ 1."

        case .incompatibleCrystalComposition:
            return """
            The selected crystal composition and mother-liquor solubility \
            do not permit a positive crystallization balance.
            """

        case .numericalFailure:
            return "The crystallization balance did not produce finite physical results."
        }
    }
}
