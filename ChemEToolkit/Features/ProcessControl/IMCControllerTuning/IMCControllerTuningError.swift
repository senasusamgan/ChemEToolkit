import Foundation

enum IMCControllerTuningError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case zeroProcessGain
    case nonPositiveTimeConstant
    case negativeDeadTime
    case nonPositiveClosedLoopTimeConstant
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All IMC tuning inputs must be finite."
        case .zeroProcessGain:
            return "Process gain cannot be zero."
        case .nonPositiveTimeConstant:
            return "Process time constant must be greater than zero."
        case .negativeDeadTime:
            return "Process dead time cannot be negative."
        case .nonPositiveClosedLoopTimeConstant:
            return "Desired closed-loop time constant λ must be greater than zero."
        case .numericalFailure:
            return "The IMC tuning calculation did not produce finite tuning values."
        }
    }
}
