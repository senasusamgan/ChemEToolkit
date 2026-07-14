import Foundation

enum HydrostaticPressureError:
    Error,
    Equatable,
    LocalizedError {

    case invalidFluidDensity
    case invalidDepth
    case invalidSurfacePressure
    case invalidGravity
    case nonFiniteResult

    var errorDescription: String? {
        switch self {
        case .invalidFluidDensity:
            return
                "Fluid density must be greater than zero."

        case .invalidDepth:
            return
                "Depth cannot be negative."

        case .invalidSurfacePressure:
            return
                "Surface pressure must be a finite number."

        case .invalidGravity:
            return
                "Gravitational acceleration must be greater than zero."

        case .nonFiniteResult:
            return
                "The calculated hydrostatic pressure is not finite."
        }
    }
}
