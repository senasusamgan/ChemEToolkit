import Foundation

enum CatalystDeactivationKineticsError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case initialActivityOutOfRange
    case nonPositiveRateConstant
    case deactivationOrderOutOfRange
    case negativeElapsedTime
    case targetActivityOutOfRange
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All catalyst-deactivation inputs must be finite."
        case .initialActivityOutOfRange:
            return "Initial catalyst activity must satisfy 0 < a₀ ≤ 1."
        case .nonPositiveRateConstant:
            return "Deactivation rate constant must be greater than zero."
        case .deactivationOrderOutOfRange:
            return "Deactivation order must satisfy 0 ≤ m ≤ 2."
        case .negativeElapsedTime:
            return "Elapsed time cannot be negative."
        case .targetActivityOutOfRange:
            return "Target activity must satisfy 0 < a_target < a₀."
        case .numericalFailure:
            return "The catalyst-deactivation calculation did not produce finite physical results."
        }
    }
}
