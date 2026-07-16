import Foundation

enum ZieglerNicholsReactionCurveTuningError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case zeroProcessGain
    case nonPositiveTimeConstant
    case nonPositiveDeadTime
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "Process gain, time constant and dead time must be finite."
        case .zeroProcessGain:
            return "Process gain cannot be zero."
        case .nonPositiveTimeConstant:
            return "Process time constant must be greater than zero."
        case .nonPositiveDeadTime:
            return "Process dead time must be greater than zero for reaction-curve tuning."
        case .numericalFailure:
            return "The Ziegler–Nichols reaction-curve calculation did not produce finite tuning values."
        }
    }
}
