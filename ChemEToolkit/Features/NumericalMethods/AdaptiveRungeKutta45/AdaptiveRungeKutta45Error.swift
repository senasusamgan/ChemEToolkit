import Foundation

enum AdaptiveRungeKutta45Error: Error, Equatable, LocalizedError {
    case nonFiniteInput
case invalidInterval
case invalidStep
case invalidTolerance
case invalidStepLimit
case stepUnderflow
case didNotConverge

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput: return "ODE parameters and solver settings must be finite."
    case .invalidInterval: return "Final x must exceed initial x."
    case .invalidStep: return "Initial step must be greater than zero."
    case .invalidTolerance: return "Tolerance must be greater than zero."
    case .invalidStepLimit: return "Maximum steps must be a positive whole number."
    case .stepUnderflow: return "Adaptive step size became too small."
    case .didNotConverge: return "The adaptive solver exceeded its step limit."
        }
    }
}
