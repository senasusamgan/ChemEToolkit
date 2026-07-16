import Foundation

enum InverseLaplaceTransformHelperError: Error, Equatable, LocalizedError {
    case nonFiniteInput
    case negativeEvaluationTime
    case nonPositiveParameter
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput: return "Amplitude, parameter and evaluation time must be finite."
        case .negativeEvaluationTime: return "Evaluation time cannot be negative."
        case .nonPositiveParameter: return "The selected transform requires a positive pole, frequency or time constant."
        case .numericalFailure: return "The inverse-Laplace calculation did not produce a finite result."
        }
    }
}
