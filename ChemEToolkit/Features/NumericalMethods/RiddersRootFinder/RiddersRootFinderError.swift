import Foundation
enum RiddersRootFinderError:Error,Equatable,LocalizedError{case invalidBounds,invalidControls,rootNotBracketed,numericalBreakdown,didNotConverge
 var errorDescription:String?{switch self{case .invalidBounds:return "Bounds must be finite and ordered.";case .invalidControls:return "Tolerance and iteration limit must be positive.";case .rootNotBracketed:return "Function values at the bounds must have opposite signs.";case .numericalBreakdown:return "Ridders interpolation encountered a numerical breakdown.";case .didNotConverge:return "The root finder did not converge."}}}
