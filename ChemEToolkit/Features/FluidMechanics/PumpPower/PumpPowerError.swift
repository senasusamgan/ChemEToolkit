import Foundation

enum PumpPowerError:
    Error,
    Equatable,
    LocalizedError {

    case invalidDensity
    case invalidFlowRate
    case invalidPumpHead
    case invalidEfficiency
    case invalidGravity
    case nonFiniteResult

    var errorDescription: String? {
        switch self {
        case .invalidDensity:
            return
                "Fluid density must be greater than zero."

        case .invalidFlowRate:
            return
                "Volumetric flow rate cannot be negative."

        case .invalidPumpHead:
            return
                "Pump head cannot be negative."

        case .invalidEfficiency:
            return
                "Pump efficiency must be greater than zero and no greater than 100%."

        case .invalidGravity:
            return
                "Gravitational acceleration must be greater than zero."

        case .nonFiniteResult:
            return
                "The calculated pump power is not finite."
        }
    }
}
