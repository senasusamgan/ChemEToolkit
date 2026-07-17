import Foundation

enum SafetyIntegrityLevelTargetError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveFrequency
    case invalidNonSISRiskReductionFactor
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All SIL-target screening inputs must be finite."
        case .nonPositiveFrequency:
            return "Unmitigated and tolerable event frequencies must be greater than zero."
        case .invalidNonSISRiskReductionFactor:
            return "Non-SIS risk-reduction factor must be at least one."
        case .numericalFailure:
            return "The SIL-target screening calculation did not produce finite results."
        }
    }
}
