import Foundation

enum ReverseOsmosisPerformanceError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveProperty
    case negativeOsmoticPressureDifference
    case insufficientNetDrivingPressure
    case recoveryOutsideLowRecoveryModel
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All reverse-osmosis inputs must be finite."

        case .nonPositiveProperty:
            return """
            Feed flow, membrane area, water permeability, applied pressure, \
            solute permeability and feed concentration must be greater than zero.
            """

        case .negativeOsmoticPressureDifference:
            return "Osmotic-pressure difference cannot be negative."

        case .insufficientNetDrivingPressure:
            return "Applied pressure difference must exceed the osmotic-pressure difference."

        case .recoveryOutsideLowRecoveryModel:
            return """
            Calculated water recovery exceeds 0.25. Reduce membrane area \
            or increase feed flow because the implemented feed-state model \
            is restricted to low recovery.
            """

        case .numericalFailure:
            return "The reverse-osmosis calculation did not produce finite physical results."
        }
    }
}
