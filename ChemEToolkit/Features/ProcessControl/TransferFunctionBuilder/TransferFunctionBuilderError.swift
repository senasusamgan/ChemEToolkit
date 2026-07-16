import Foundation

enum TransferFunctionBuilderError: Error, Equatable, LocalizedError {
    case nonFiniteInput
    case zeroDenominatorPolynomial
    case negativeAngularFrequency
    case frequencyDenominatorZero
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput: return "All transfer-function coefficients and angular frequency must be finite."
        case .zeroDenominatorPolynomial: return "At least one denominator coefficient must be nonzero."
        case .negativeAngularFrequency: return "Angular frequency cannot be negative."
        case .frequencyDenominatorZero: return "The denominator evaluates to zero at the selected angular frequency."
        case .numericalFailure: return "The transfer-function calculation did not produce finite results."
        }
    }
}
