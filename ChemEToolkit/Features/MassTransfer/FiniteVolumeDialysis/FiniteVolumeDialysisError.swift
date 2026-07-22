import Foundation

enum FiniteVolumeDialysisError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveProperty
    case negativeContactTime
    case negativeConcentration
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All dialysis inputs must be finite."

        case .nonPositiveProperty:
            return """
            Donor volume, receiver volume, membrane area and overall \
            mass-transfer coefficient must be greater than zero.
            """

        case .negativeContactTime:
            return "Contact time cannot be negative."

        case .negativeConcentration:
            return "Initial concentrations cannot be negative."

        case .numericalFailure:
            return "The finite-volume dialysis calculation did not produce finite physical results."
        }
    }
}
