import Foundation
enum AdaptiveSimpsonIntegrationError: Error, Equatable, LocalizedError {
 case invalidBounds, invalidControls, maximumDepthReached
 var errorDescription: String? { switch self { case .invalidBounds: return "Bounds must be finite and distinct."; case .invalidControls: return "Tolerance and maximum depth must be positive."; case .maximumDepthReached: return "Requested tolerance was not reached before the recursion limit." } }
}
