import Foundation

enum LumpedCapacitanceError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveMass
    case nonPositiveSpecificHeatCapacity
    case nonPositiveHeatTransferCoefficient
    case nonPositiveSurfaceArea
    case negativeElapsedTime
    case nonPositiveThermalConductivity
    case nonPositiveCharacteristicLength

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All entered values must be finite numbers."

        case .nonPositiveMass:
            return "Object mass must be greater than zero."

        case .nonPositiveSpecificHeatCapacity:
            return "Specific heat capacity must be greater than zero."

        case .nonPositiveHeatTransferCoefficient:
            return "Heat-transfer coefficient must be greater than zero."

        case .nonPositiveSurfaceArea:
            return "Surface area must be greater than zero."

        case .negativeElapsedTime:
            return "Elapsed time cannot be negative."

        case .nonPositiveThermalConductivity:
            return "Object thermal conductivity must be greater than zero."

        case .nonPositiveCharacteristicLength:
            return "Characteristic length must be greater than zero."
        }
    }
}
