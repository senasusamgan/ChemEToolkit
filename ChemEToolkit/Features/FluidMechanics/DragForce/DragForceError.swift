import Foundation

enum DragForceError:
    Error,
    Equatable,
    LocalizedError {

    case invalidFluidDensity
    case invalidVelocity
    case invalidProjectedArea
    case invalidDragCoefficient
    case nonFiniteResult

    var errorDescription: String? {
        switch self {
        case .invalidFluidDensity:
            return "Fluid density must be greater than zero."

        case .invalidVelocity:
            return "Relative velocity cannot be negative."

        case .invalidProjectedArea:
            return "Projected area must be greater than zero."

        case .invalidDragCoefficient:
            return "Drag coefficient cannot be negative."

        case .nonFiniteResult:
            return "The calculated drag-force result is not finite."
        }
    }
}
