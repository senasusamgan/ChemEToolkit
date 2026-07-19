import Foundation
enum LevenbergMarquardtRegressionError: Error, Equatable, LocalizedError {
    case invalidData, nonFiniteInput, invalidInitialParameters, invalidControls, singularNormalMatrix, didNotConverge
    var errorDescription: String? {
        switch self {
        case .invalidData: return "At least three paired x and y values are required."
        case .nonFiniteInput: return "All inputs must be finite."
        case .invalidInitialParameters: return "Exactly two initial parameters are required; saturation b must remain positive."
        case .invalidControls: return "Damping, tolerance, and maximum iterations must be greater than zero."
        case .singularNormalMatrix: return "The damped normal matrix became singular."
        case .didNotConverge: return "The regression did not converge within the iteration limit."
        }
    }
}
