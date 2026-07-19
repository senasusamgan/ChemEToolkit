import Foundation
enum NewtonRaphsonNonlinearSystemError: Error, Equatable, LocalizedError {
    case invalidInitialGuess, invalidParameter, invalidControls, singularJacobian, didNotConverge
    var errorDescription: String? {
        switch self {
        case .invalidInitialGuess: return "This solver requires exactly two finite initial values."
        case .invalidParameter: return "The equilibrium parameter must be finite and between 0 and 0.25."
        case .invalidControls: return "Tolerance and maximum iterations must be greater than zero."
        case .singularJacobian: return "The Jacobian approximation became singular. Try a different initial guess."
        case .didNotConverge: return "The nonlinear system did not converge within the iteration limit."
        }
    }
}
