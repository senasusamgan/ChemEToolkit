import Foundation

enum BiotNumberError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveHeatTransferCoefficient
    case nonPositiveCharacteristicLength
    case nonPositiveSolidThermalConductivity

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All entered values must be finite numbers."

        case .nonPositiveHeatTransferCoefficient:
            return "Heat-transfer coefficient must be greater than zero."

        case .nonPositiveCharacteristicLength:
            return "Characteristic length must be greater than zero."

        case .nonPositiveSolidThermalConductivity:
            return "Solid thermal conductivity must be greater than zero."
        }
    }
}
