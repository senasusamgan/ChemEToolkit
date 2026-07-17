import Foundation

enum ProofTestIntervalCalculatorError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveFailureRate
    case diagnosticCoverageOutsideRange
    case negativeRepairTime
    case commonCausePFDOutsideRange
    case targetPFDOutsideRange
    case noRemainingPFDBudget
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All proof-test interval inputs must be finite."
        case .nonPositiveFailureRate:
            return "Dangerous failure rate must be greater than zero."
        case .diagnosticCoverageOutsideRange:
            return "Diagnostic coverage must satisfy 0 ≤ DC < 1."
        case .negativeRepairTime:
            return "Mean repair time cannot be negative."
        case .commonCausePFDOutsideRange:
            return "Common-cause PFD must lie between zero and one."
        case .targetPFDOutsideRange:
            return "Target average PFD must satisfy 0 < target PFD ≤ 1."
        case .noRemainingPFDBudget:
            return "Detected and common-cause contributions already consume the target PFD budget."
        case .numericalFailure:
            return "The proof-test interval calculation did not produce finite results."
        }
    }
}
