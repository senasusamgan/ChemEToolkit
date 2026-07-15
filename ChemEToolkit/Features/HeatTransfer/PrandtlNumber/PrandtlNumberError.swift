import Foundation

enum PrandtlNumberError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveDynamicViscosity
    case nonPositiveSpecificHeatCapacity
    case nonPositiveThermalConductivity

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All entered values must be finite numbers."

        case .nonPositiveDynamicViscosity:
            return "Dynamic viscosity must be greater than zero."

        case .nonPositiveSpecificHeatCapacity:
            return "Specific heat capacity must be greater than zero."

        case .nonPositiveThermalConductivity:
            return "Thermal conductivity must be greater than zero."
        }
    }
}
