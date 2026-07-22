import Foundation
enum TanksInSeriesRTDError: Error, Equatable, LocalizedError {
    case nonFiniteInput, nonPositiveMeanResidenceTime, invalidTankCount
    case negativeEvaluationTime, numericalFailure
    var errorDescription: String? {
        switch self {
        case .nonFiniteInput: return "All tanks-in-series inputs must be finite."
        case .nonPositiveMeanResidenceTime: return "Mean residence time must be greater than zero."
        case .invalidTankCount: return "Number of tanks must be a whole number from 1 through 100."
        case .negativeEvaluationTime: return "Evaluation time cannot be negative."
        case .numericalFailure: return "The tanks-in-series RTD calculation failed."
        }
    }
}
