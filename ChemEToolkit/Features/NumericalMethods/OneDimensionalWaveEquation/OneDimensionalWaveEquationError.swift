import Foundation
enum OneDimensionalWaveEquationError:Error,Equatable,LocalizedError{case nonFiniteInput,invalidPhysicalValues,invalidGrid,unstableCourantNumber
 var errorDescription:String?{switch self{case .nonFiniteInput:return "All physical values must be finite.";case .invalidPhysicalValues:return "Wave speed, length, and total time must be positive.";case .invalidGrid:return "Use at least three spatial nodes and one time step.";case .unstableCourantNumber:return "The explicit scheme requires a Courant number no greater than one."}}
}
