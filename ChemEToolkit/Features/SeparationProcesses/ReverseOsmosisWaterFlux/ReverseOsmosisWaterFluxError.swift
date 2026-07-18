import Foundation

enum ReverseOsmosisWaterFluxError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositivePermeabilityOrFlow
    case nonPositiveNetDrivingPressure
    case invalidRecovery
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "Pressures, permeability, flow and recovery must be finite."
        case .nonPositivePermeabilityOrFlow:
            return "Water permeability and target permeate flow must be greater than zero."
        case .nonPositiveNetDrivingPressure:
            return "Hydraulic pressure difference must exceed osmotic pressure difference."
        case .invalidRecovery:
            return "Recovery must be greater than zero and less than one."
        case .numericalFailure:
            return "The reverse-osmosis calculation did not produce finite results."
        }
    }
}
