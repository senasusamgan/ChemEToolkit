import Foundation
enum HighOrderFiniteDifferenceError: Error, Equatable, LocalizedError { case nonFiniteInput, invalidStep
 var errorDescription: String? { self == .nonFiniteInput ? "Point and step must be finite." : "Step size must be positive." }
}
