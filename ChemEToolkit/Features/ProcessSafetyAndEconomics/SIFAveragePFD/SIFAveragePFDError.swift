import Foundation

enum SIFAveragePFDError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveFailureRate
    case diagnosticCoverageOutsideRange
    case nonPositiveProofTestInterval
    case negativeRepairTime
    case commonCausePFDOutsideRange
    case modelOutsideProbabilityRange
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All SIF PFD inputs must be finite."
        case .nonPositiveFailureRate:
            return "Dangerous failure rate must be greater than zero."
        case .diagnosticCoverageOutsideRange:
            return "Diagnostic coverage must lie between zero and one."
        case .nonPositiveProofTestInterval:
            return "Proof-test interval must be greater than zero."
        case .negativeRepairTime:
            return "Mean repair time cannot be negative."
        case .commonCausePFDOutsideRange:
            return "Common-cause PFD must lie between zero and one."
        case .modelOutsideProbabilityRange:
            return "The simplified PFD result exceeds one; reduce the interval or use a more appropriate reliability model."
        case .numericalFailure:
            return "The SIF PFD calculation did not produce finite results."
        }
    }
}
