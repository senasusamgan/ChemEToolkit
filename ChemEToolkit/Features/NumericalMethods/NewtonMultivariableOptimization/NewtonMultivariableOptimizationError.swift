import Foundation
enum NewtonMultivariableOptimizationError: Error, Equatable, LocalizedError { case invalidInitialPoint, invalidControls, singularHessian, didNotConverge
 var errorDescription:String? { switch self { case .invalidInitialPoint:return "Exactly two finite coordinates are required.";case .invalidControls:return "Tolerance and iteration limit must be positive.";case .singularHessian:return "The Hessian is singular at the current point.";case .didNotConverge:return "Newton optimization did not converge." } }
}
