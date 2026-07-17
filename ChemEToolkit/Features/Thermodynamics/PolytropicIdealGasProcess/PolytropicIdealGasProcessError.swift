import Foundation

enum PolytropicIdealGasProcessError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositivePressure
    case nonPositiveVolume
    case nonPositiveExponent
    case isothermalExponentUnsupported
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "Pressures, volume and polytropic exponent must be finite."
        case .nonPositivePressure:
            return "Initial and final absolute pressures must be greater than zero."
        case .nonPositiveVolume:
            return "Initial volume must be greater than zero."
        case .nonPositiveExponent:
            return "Polytropic exponent must be greater than zero."
        case .isothermalExponentUnsupported:
            return "Use the dedicated isothermal module when the polytropic exponent equals one."
        case .numericalFailure:
            return "The polytropic-process calculation did not produce finite results."
        }
    }
}
