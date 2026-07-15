import Foundation

enum SphericalWallConductionError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveThermalConductivity
    case nonPositiveInnerRadius
    case invalidOuterRadius
    case invalidTemperatureOrder

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All entered values must be finite numbers."

        case .nonPositiveThermalConductivity:
            return "Thermal conductivity must be greater than zero."

        case .nonPositiveInnerRadius:
            return "Inner radius must be greater than zero."

        case .invalidOuterRadius:
            return "Outer radius must be greater than the inner radius."

        case .invalidTemperatureOrder:
            return "Inner-surface temperature cannot be lower than the outer-surface temperature."
        }
    }
}
