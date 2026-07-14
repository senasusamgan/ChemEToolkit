import Foundation

enum ParticleSettlingError:
    Error,
    Equatable,
    LocalizedError {

    case invalidParticleDensity
    case invalidFluidDensity
    case invalidParticleDiameter
    case invalidDynamicViscosity
    case invalidGravity
    case nonFiniteResult

    var errorDescription: String? {
        switch self {
        case .invalidParticleDensity:
            return "Particle density must be greater than zero."

        case .invalidFluidDensity:
            return "Fluid density must be greater than zero."

        case .invalidParticleDiameter:
            return "Particle diameter must be greater than zero."

        case .invalidDynamicViscosity:
            return "Dynamic viscosity must be greater than zero."

        case .invalidGravity:
            return "Gravitational acceleration must be greater than zero."

        case .nonFiniteResult:
            return "The calculated settling result is not finite."
        }
    }
}
