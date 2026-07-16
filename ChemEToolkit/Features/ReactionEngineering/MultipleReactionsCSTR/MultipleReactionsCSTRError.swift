import Foundation

enum MultipleReactionsCSTRError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveConcentrationOrFlow
    case nonPositiveRateConstant
    case conversionOutOfRange
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All multiple-reaction CSTR inputs must be finite."
        case .nonPositiveConcentrationOrFlow:
            return "Inlet concentration and volumetric flow rate must be greater than zero."
        case .nonPositiveRateConstant:
            return "Both first-order rate constants must be greater than zero."
        case .conversionOutOfRange:
            return "Target conversion must satisfy 0 < X_A < 1."
        case .numericalFailure:
            return "The multiple-reaction CSTR calculation did not produce finite physical results."
        }
    }
}
