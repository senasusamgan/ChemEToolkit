import Foundation
enum MonteCarloIntegrationError: Error, Equatable, LocalizedError { case invalidBounds, insufficientSamples
 var errorDescription:String? { self == .invalidBounds ? "Bounds must be finite and distinct." : "At least two samples are required." } }
