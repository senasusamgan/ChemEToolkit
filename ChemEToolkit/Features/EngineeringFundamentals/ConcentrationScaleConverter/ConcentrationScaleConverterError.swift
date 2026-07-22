import Foundation

enum ConcentrationScaleConverterError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case negativeValue
    case invalidScaleCode
    case fractionAboveOne
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "Entered value and scale code must be finite."
        case .negativeValue:
            return "Concentration value cannot be negative."
        case .invalidScaleCode:
            return "Scale code must be 1 for percent, 2 for ppm or 3 for ppb."
        case .fractionAboveOne:
            return "The converted dimensionless fraction cannot exceed one."
        case .numericalFailure:
            return "The concentration-scale conversion did not produce finite results."
        }
    }
}
