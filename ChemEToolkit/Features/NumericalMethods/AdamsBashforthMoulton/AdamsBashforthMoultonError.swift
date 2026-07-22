import Foundation
enum AdamsBashforthMoultonError:Error,Equatable,LocalizedError{case nonFiniteInput,invalidInterval,invalidStep,insufficientSteps
 var errorDescription:String?{switch self{case .nonFiniteInput:return "All values must be finite.";case .invalidInterval:return "Final x must exceed initial x.";case .invalidStep:return "Step size must be positive.";case .insufficientSteps:return "At least four integration steps are required."}}
}
