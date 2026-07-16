import Foundation

enum ClosedLoopFeedbackAnalysisError: Error, Equatable, LocalizedError {
    case nonFiniteInput
    case singularClosedLoop
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput: return "All closed-loop feedback inputs must be finite."
        case .singularClosedLoop: return "The static closed-loop denominator 1 + GH is zero or too close to zero."
        case .numericalFailure: return "The closed-loop feedback calculation did not produce finite results."
        }
    }
}
