import Foundation
enum LaplaceEquationFiniteDifferenceError:Error,Equatable,LocalizedError{case invalidGrid,nonFiniteInput,invalidControls,didNotConverge
 var errorDescription:String?{switch self{case .invalidGrid:return "Grid dimensions must each be at least three.";case .nonFiniteInput:return "Boundary values must be finite.";case .invalidControls:return "Tolerance and iteration limit must be positive.";case .didNotConverge:return "The field did not converge within the iteration limit."}}
}
