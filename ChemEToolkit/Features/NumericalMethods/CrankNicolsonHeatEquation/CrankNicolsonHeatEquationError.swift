import Foundation
enum CrankNicolsonHeatEquationError:Error,Equatable,LocalizedError{case nonFiniteInput,invalidPhysicalValues,invalidGrid
 var errorDescription:String?{switch self{case .nonFiniteInput:return "All physical values must be finite.";case .invalidPhysicalValues:return "Diffusivity, length, and total time must be positive.";case .invalidGrid:return "Use at least three spatial nodes and one time step."}}
}
