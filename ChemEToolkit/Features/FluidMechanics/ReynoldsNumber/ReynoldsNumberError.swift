import Foundation

enum ReynoldsNumberError:
    Error,
    Equatable,
    LocalizedError {

    case invalidVelocity
    case invalidDiameter
    case invalidDensity
    case invalidDynamicViscosity
    case invalidKinematicViscosity

    var errorDescription: String? {
        switch self {
        case .invalidVelocity:
            return "Velocity must be greater than zero."

        case .invalidDiameter:
            return "Pipe diameter must be greater than zero."

        case .invalidDensity:
            return "Fluid density must be greater than zero."

        case .invalidDynamicViscosity:
            return "Dynamic viscosity must be greater than zero."

        case .invalidKinematicViscosity:
            return "Kinematic viscosity must be greater than zero."
        }
    }
}
