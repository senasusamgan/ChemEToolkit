import Foundation

enum CatalystRegenerationCycleError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case initialActivityOutOfRange
    case nonPositiveRateConstant
    case nonPositiveOperatingTime
    case recoveryFractionOutOfRange
    case invalidCycleCount
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All catalyst regeneration-cycle inputs must be finite."
        case .initialActivityOutOfRange:
            return "Initial catalyst activity must satisfy 0 < a₀ ≤ 1."
        case .nonPositiveRateConstant:
            return "First-order deactivation rate constant must be greater than zero."
        case .nonPositiveOperatingTime:
            return "Operating time per cycle must be greater than zero."
        case .recoveryFractionOutOfRange:
            return "Regeneration recovery fraction must satisfy 0 ≤ r ≤ 1."
        case .invalidCycleCount:
            return "Number of cycles must be a whole number from 1 through 10000."
        case .numericalFailure:
            return "The regeneration-cycle calculation did not produce finite physical results."
        }
    }
}
