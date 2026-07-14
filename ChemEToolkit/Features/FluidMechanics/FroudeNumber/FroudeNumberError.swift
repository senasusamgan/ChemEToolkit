import Foundation

enum FroudeNumberError:
    Error,
    Equatable,
    LocalizedError {

    case invalidVelocity
    case invalidHydraulicDepth
    case invalidGravity
    case nonFiniteResult

    var errorDescription: String? {
        switch self {
        case .invalidVelocity:
            return
                "Average flow velocity cannot be negative."

        case .invalidHydraulicDepth:
            return
                "Hydraulic depth must be greater than zero."

        case .invalidGravity:
            return
                "Gravitational acceleration must be greater than zero."

        case .nonFiniteResult:
            return
                "The calculated Froude number is not finite."
        }
    }
}
