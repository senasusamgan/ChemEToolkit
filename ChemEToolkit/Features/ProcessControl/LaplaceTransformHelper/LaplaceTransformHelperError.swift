import Foundation

enum LaplaceTransformHelperError: Error, Equatable, LocalizedError {
    case nonFiniteInput
    case nonPositiveEvaluationS
    case invalidFrequency
    case outsideConvergenceRegion
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput: return "Amplitude, function parameter and evaluation value s must be finite."
        case .nonPositiveEvaluationS: return "The real evaluation value s must be greater than zero."
        case .invalidFrequency: return "Sine and cosine angular frequency must be greater than zero."
        case .outsideConvergenceRegion: return "The selected s value lies outside the convergence region for the exponential transform."
        case .numericalFailure: return "The Laplace-transform calculation did not produce a finite result."
        }
    }
}
