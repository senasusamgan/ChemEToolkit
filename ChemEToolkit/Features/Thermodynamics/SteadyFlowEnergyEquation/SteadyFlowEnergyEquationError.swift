import Foundation

enum SteadyFlowEnergyEquationError: Error, Equatable, LocalizedError {
    case nonFiniteInput
    case nonPositiveMassFlow
    case negativeVelocity
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "Flow, work, state, velocity and elevation inputs must be finite."
        case .nonPositiveMassFlow:
            return "Mass flow rate must be greater than zero."
        case .negativeVelocity:
            return "Inlet and outlet velocities cannot be negative."
        case .numericalFailure:
            return "The steady-flow energy calculation did not produce finite results."
        }
    }
}
