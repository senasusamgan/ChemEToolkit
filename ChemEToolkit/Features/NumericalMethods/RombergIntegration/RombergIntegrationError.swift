import Foundation
enum RombergIntegrationError: Error, Equatable, LocalizedError { case invalidBounds, invalidLevels
 var errorDescription: String? { self == .invalidBounds ? "Bounds must be finite and distinct." : "Romberg levels must be between 2 and 12." } }
