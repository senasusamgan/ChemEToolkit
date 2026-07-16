import Foundation

enum CohenCoonTuningError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case zeroProcessGain
    case nonPositiveTimeConstant
    case nonPositiveDeadTime
    case deadTimeRatioOutOfRange
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
            return "Process dead time must be greater than zero."
        case .deadTimeRatioOutOfRange:
            return "Cohen–Coon tuning is restricted here to 0 < θ/τ ≤ 1."
        case .numericalFailure:
            return "The Cohen–Coon calculation did not produce finite tuning values."
        }
    }
}
