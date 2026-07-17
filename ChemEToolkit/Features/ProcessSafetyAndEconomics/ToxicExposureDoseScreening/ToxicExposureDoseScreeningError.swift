import Foundation

enum ToxicExposureDoseScreeningError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveConcentration
    case nonPositiveDuration
    case nonPositiveExponent
    case nonPositiveReferenceDose
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All toxic-exposure screening inputs must be finite."
        case .nonPositiveConcentration:
            return "Exposure concentration must be greater than zero."
        case .nonPositiveDuration:
            return "Exposure duration must be greater than zero."
        case .nonPositiveExponent:
            return "Concentration exponent must be greater than zero."
        case .nonPositiveReferenceDose:
            return "Reference dose must be greater than zero."
        case .numericalFailure:
            return "The toxic-exposure dose calculation did not produce finite results."
        }
    }
}
