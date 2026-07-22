import Foundation
enum NelderMeadOptimizationError:Error,Equatable,LocalizedError{case invalidInitialPoint,invalidControls,didNotConverge
 var errorDescription:String?{switch self{case .invalidInitialPoint:return "Exactly two finite initial coordinates are required.";case .invalidControls:return "Step, tolerance, and iteration limit must be positive.";case .didNotConverge:return "The simplex did not converge within the iteration limit."}}}
