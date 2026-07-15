import Foundation

enum NaturalConvectionCorrelationError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveRayleighNumber
    case nonPositivePrandtlNumber
    case nonPositiveThermalConductivity
    case nonPositiveCharacteristicLength

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All entered values must be finite numbers."
        case .nonPositiveRayleighNumber:
            return "Rayleigh number must be greater than zero."
        case .nonPositivePrandtlNumber:
            return "Prandtl number must be greater than zero."
        case .nonPositiveThermalConductivity:
            return "Fluid thermal conductivity must be greater than zero."
        case .nonPositiveCharacteristicLength:
            return "Characteristic length must be greater than zero."
        }
    }
}
