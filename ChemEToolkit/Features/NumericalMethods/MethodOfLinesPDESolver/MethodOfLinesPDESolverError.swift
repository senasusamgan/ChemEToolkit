import Foundation

enum MethodOfLinesPDESolverError: Error, Equatable, LocalizedError {
    case nonFiniteInput
    case invalidPhysicalValues
    case invalidGrid
    case unstableTimeStep
    case nonFiniteSolution

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All physical inputs must be finite."
        case .invalidPhysicalValues:
            return "Diffusivity, length, and time must be positive; reaction rate and concentrations must be nonnegative."
        case .invalidGrid:
            return "Use at least three spatial nodes and one time step."
        case .unstableTimeStep:
            return "Reduce the time step so the diffusion number is at most 0.5 and the reaction number is at most 1."
        case .nonFiniteSolution:
            return "The numerical solution became non-finite."
        }
    }
}
