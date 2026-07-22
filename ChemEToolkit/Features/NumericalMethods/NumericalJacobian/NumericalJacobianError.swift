import Foundation
enum NumericalJacobianError: Error, Equatable, LocalizedError { case invalidPoint, invalidStep
 var errorDescription: String? { self == .invalidPoint ? "Exactly two finite coordinates are required." : "Step size must be finite and positive." }
}
