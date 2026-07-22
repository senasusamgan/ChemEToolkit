import Foundation

enum GainSchedulingError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case invalidOperatingRange
    case operatingPointOutsideSchedule
    case nonPositiveIntegralTime
    case negativeDerivativeTime
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All gain-scheduling inputs must be finite."
        case .invalidOperatingRange:
            return "Lower operating point must be less than upper operating point."
        case .operatingPointOutsideSchedule:
            return "Operating point must lie within the defined scheduling range."
        case .nonPositiveIntegralTime:
            return "Lower and upper integral times must be greater than zero."
        case .negativeDerivativeTime:
            return "Lower and upper derivative times cannot be negative."
        case .numericalFailure:
            return "The gain-scheduling calculation did not produce finite results."
        }
    }
}
