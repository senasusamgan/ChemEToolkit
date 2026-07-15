import Foundation

enum GrashofNumberError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveGravity
    case nonPositiveThermalExpansionCoefficient
    case nonPositiveCharacteristicLength
    case nonPositiveKinematicViscosity

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All entered values must be finite numbers."

        case .nonPositiveGravity:
            return "Gravitational acceleration must be greater than zero."

        case .nonPositiveThermalExpansionCoefficient:
            return "Thermal expansion coefficient must be greater than zero."

        case .nonPositiveCharacteristicLength:
            return "Characteristic length must be greater than zero."

        case .nonPositiveKinematicViscosity:
            return "Kinematic viscosity must be greater than zero."
        }
    }
}
