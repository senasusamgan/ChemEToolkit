import Foundation

enum AutocatalyticBatchReactorError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveInitialConcentration
    case nonPositiveRateConstant
    case conversionOutOfRange
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All autocatalytic batch inputs must be finite."
        case .nonPositiveInitialConcentration:
            return "Initial concentrations of A and autocatalyst B must be greater than zero."
        case .nonPositiveRateConstant:
            return "Rate constant must be greater than zero."
        case .conversionOutOfRange:
            return "Target conversion must satisfy 0 < X_A < 1."
        case .numericalFailure:
            return "The autocatalytic batch calculation did not produce finite physical results."
        }
    }
}
