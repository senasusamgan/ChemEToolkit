import Foundation

enum SocietalRiskFNScreeningError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveFrequency
    case invalidFatalityCount
    case nonPositiveSlopeExponent
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All F–N screening inputs must be finite."
        case .nonPositiveFrequency:
            return "Entered and reference frequencies must be greater than zero."
        case .invalidFatalityCount:
            return "Fatality count must be a whole number of at least one."
        case .nonPositiveSlopeExponent:
            return "Criterion slope exponent must be greater than zero."
        case .numericalFailure:
            return "The F–N screening calculation did not produce finite results."
        }
    }
}
