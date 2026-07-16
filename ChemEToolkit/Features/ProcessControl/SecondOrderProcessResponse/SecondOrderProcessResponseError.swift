import Foundation

enum SecondOrderProcessResponseError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveNaturalFrequency
    case nonPositiveDampingRatio
    case negativeEvaluationTime
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All second-order process inputs must be finite."
        case .nonPositiveNaturalFrequency:
            return "Natural frequency must be greater than zero."
        case .nonPositiveDampingRatio:
            return "Damping ratio must be greater than zero."
        case .negativeEvaluationTime:
            return "Evaluation time cannot be negative."
        case .numericalFailure:
            return "The second-order response calculation did not produce finite results."
        }
    }
}
