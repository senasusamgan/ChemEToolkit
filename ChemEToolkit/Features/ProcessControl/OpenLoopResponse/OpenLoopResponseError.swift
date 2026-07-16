import Foundation

enum OpenLoopResponseError: Error, Equatable, LocalizedError {
    case nonFiniteInput
    case invalidControllerLimits
    case nonPositiveProcessTimeConstant
    case negativeProcessDeadTime
    case negativeEvaluationTime
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput: return "All open-loop response inputs must be finite."
        case .invalidControllerLimits: return "Minimum controller output must be less than maximum controller output."
        case .nonPositiveProcessTimeConstant: return "Process time constant must be greater than zero."
        case .negativeProcessDeadTime: return "Process dead time cannot be negative."
        case .negativeEvaluationTime: return "Evaluation time cannot be negative."
        case .numericalFailure: return "The open-loop response calculation did not produce finite results."
        }
    }
}
