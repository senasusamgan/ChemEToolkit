import Foundation

enum RaoultDewPointPressureError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case fractionOutsideRange
    case nonPositiveSaturationPressure
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "Composition and saturation pressures must be finite."
        case .fractionOutsideRange:
            return "Vapor mole fraction must lie between zero and one."
        case .nonPositiveSaturationPressure:
            return "Both saturation pressures must be greater than zero."
        case .numericalFailure:
            return "The dew-point calculation did not produce finite results."
        }
    }
}
