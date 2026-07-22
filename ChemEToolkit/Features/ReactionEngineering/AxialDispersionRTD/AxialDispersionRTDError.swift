import Foundation
enum AxialDispersionRTDError: Error, Equatable, LocalizedError {
    case nonFiniteInput, nonPositiveMeanResidenceTime, pecletOutOfRange
    case nonPositiveEvaluationTime, numericalFailure
    var errorDescription: String? {
        switch self {
        case .nonFiniteInput: return "All axial-dispersion inputs must be finite."
        case .nonPositiveMeanResidenceTime: return "Mean residence time must be greater than zero."
        case .pecletOutOfRange: return "Peclet number must satisfy 0.1 ≤ Pe ≤ 10000."
        case .nonPositiveEvaluationTime: return "Evaluation time must be greater than zero."
        case .numericalFailure: return "The axial-dispersion RTD calculation failed."
        }
    }
}
