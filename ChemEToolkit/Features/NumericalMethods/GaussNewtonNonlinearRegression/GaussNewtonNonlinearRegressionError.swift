import Foundation

enum GaussNewtonNonlinearRegressionError: Error, Equatable, LocalizedError {
    case nonFiniteInput
case nonPositiveResponse
case invalidInitialA
case invalidTolerance
case invalidIterationLimit
case singularNormalMatrix
case didNotConverge

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput: return "Data and solver settings must be finite."
    case .nonPositiveResponse: return "All y values must be greater than zero."
    case .invalidInitialA: return "Initial parameter a must be greater than zero."
    case .invalidTolerance: return "Tolerance must be greater than zero."
    case .invalidIterationLimit: return "Maximum iterations must be a positive whole number."
    case .singularNormalMatrix: return "The normal matrix became singular."
    case .didNotConverge: return "The regression did not converge."
        }
    }
}
