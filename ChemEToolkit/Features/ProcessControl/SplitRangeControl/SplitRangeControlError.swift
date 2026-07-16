import Foundation

enum SplitRangeControlError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case invalidControllerRange
    case invalidActuatorRange
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All split-range inputs must be finite."
        case .invalidControllerRange:
            return "Controller minimum must be below the split point, and the split point must be below the controller maximum."
        case .invalidActuatorRange:
            return "Each actuator minimum signal must be less than or equal to its maximum signal."
        case .numericalFailure:
            return "The split-range calculation did not produce finite results."
        }
    }
}
