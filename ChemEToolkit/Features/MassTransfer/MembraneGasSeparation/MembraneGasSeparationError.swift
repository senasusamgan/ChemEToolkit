import Foundation

enum MembraneGasSeparationError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveProperty
    case negativePermeatePressure
    case invalidPressureOrdering
    case feedCompositionOutOfRange
    case invalidPermeanceOrdering
    case noPhysicalPermeateComposition
    case stageCutOutsideLowStageCutApproximation
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All membrane inputs must be finite."

        case .nonPositiveProperty:
            return """
            Feed flow, membrane area, feed pressure and both \
            component permeances must be greater than zero.
            """

        case .negativePermeatePressure:
            return "Permeate pressure cannot be negative."

        case .invalidPressureOrdering:
            return "Feed pressure must be greater than permeate pressure."

        case .feedCompositionOutOfRange:
            return "Feed fast-component mole fraction must lie strictly between zero and one."

        case .invalidPermeanceOrdering:
            return """
            The selected fast component must have a permeance \
            greater than the slow-component permeance.
            """

        case .noPhysicalPermeateComposition:
            return "A positive-flux self-consistent permeate composition could not be found."

        case .stageCutOutsideLowStageCutApproximation:
            return """
            Calculated stage cut exceeds 0.20. Reduce membrane area \
            or increase feed flow because the implemented feed-side \
            composition approximation is limited to low stage cut.
            """

        case .numericalFailure:
            return "The membrane-separation calculation did not produce finite physical results."
        }
    }
}
