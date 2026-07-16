import Foundation

enum ZieglerNicholsUltimateGainTuningError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveUltimateGain
    case nonPositiveUltimatePeriod
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "Ultimate gain and ultimate period must be finite."
        case .nonPositiveUltimateGain:
            return "Ultimate gain must be greater than zero."
        case .nonPositiveUltimatePeriod:
            return "Ultimate period must be greater than zero."
        case .numericalFailure:
            return "The Ziegler–Nichols ultimate-gain calculation did not produce finite positive tuning values."
        }
    }
}
