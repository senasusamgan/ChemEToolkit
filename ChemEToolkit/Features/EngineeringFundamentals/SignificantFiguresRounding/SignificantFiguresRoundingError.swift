import Foundation

enum SignificantFiguresRoundingError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case invalidSignificantDigitCount
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "Value and significant-digit count must be finite."
        case .invalidSignificantDigitCount:
            return "Significant-digit count must be a whole number from 1 through 15."
        case .numericalFailure:
            return "The significant-figure rounding did not produce finite results."
        }
    }
}
