import Foundation

enum CatalystTimeOnStreamError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveDamkohlerNumber
    case nonPositiveDeactivationRate
    case conversionOutOfRange
    case freshReactorBelowTarget
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "Fresh Damköhler number, deactivation rate and minimum conversion must be finite."
        case .nonPositiveDamkohlerNumber:
            return "Fresh Damköhler number must be greater than zero."
        case .nonPositiveDeactivationRate:
            return "First-order deactivation rate constant must be greater than zero."
        case .conversionOutOfRange:
            return "Minimum acceptable conversion must satisfy 0 < X_min < 1."
        case .freshReactorBelowTarget:
            return "The fresh PFR or fresh CSTR cannot meet the selected minimum conversion at this Damköhler number."
        case .numericalFailure:
            return "The time-on-stream calculation did not produce finite physical results."
        }
    }
}
