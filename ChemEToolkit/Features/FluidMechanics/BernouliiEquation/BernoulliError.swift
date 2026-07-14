import Foundation

enum BernoulliError:
    Error,
    Equatable,
    LocalizedError {

    case invalidDensity
    case invalidGravity

    case invalidInletPressure
    case invalidInletVelocity
    case invalidInletElevation
    case invalidInletCorrectionFactor

    case invalidOutletVelocity
    case invalidOutletElevation
    case invalidOutletCorrectionFactor

    case invalidPumpHead
    case invalidTurbineHead
    case invalidHeadLoss

    case nonFiniteResult

    var errorDescription: String? {
        switch self {
        case .invalidDensity:
            return
                "Fluid density must be greater than zero."

        case .invalidGravity:
            return
                "Gravitational acceleration must be greater than zero."

        case .invalidInletPressure:
            return
                "Inlet pressure must be a finite number."

        case .invalidInletVelocity:
            return
                "Inlet velocity cannot be negative."

        case .invalidInletElevation:
            return
                "Inlet elevation must be a finite number."

        case .invalidInletCorrectionFactor:
            return
                "The inlet kinetic-energy correction factor must be greater than zero."

        case .invalidOutletVelocity:
            return
                "Outlet velocity cannot be negative."

        case .invalidOutletElevation:
            return
                "Outlet elevation must be a finite number."

        case .invalidOutletCorrectionFactor:
            return
                "The outlet kinetic-energy correction factor must be greater than zero."

        case .invalidPumpHead:
            return
                "Pump head cannot be negative."

        case .invalidTurbineHead:
            return
                "Turbine head cannot be negative."

        case .invalidHeadLoss:
            return
                "Head loss cannot be negative."

        case .nonFiniteResult:
            return
                "The calculated outlet pressure is not finite."
        }
    }
}
