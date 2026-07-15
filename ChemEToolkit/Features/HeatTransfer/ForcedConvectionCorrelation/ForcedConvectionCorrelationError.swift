import Foundation

enum ForcedConvectionCorrelationError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveReynoldsNumber
    case nonPositivePrandtlNumber
    case nonPositiveThermalConductivity
    case nonPositiveCharacteristicLength
    case unsupportedRange

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All entered values must be finite numbers."
        case .nonPositiveReynoldsNumber:
            return "Reynolds number must be greater than zero."
        case .nonPositivePrandtlNumber:
            return "Prandtl number must be greater than zero."
        case .nonPositiveThermalConductivity:
            return "Fluid thermal conductivity must be greater than zero."
        case .nonPositiveCharacteristicLength:
            return "Characteristic length must be greater than zero."
        case .unsupportedRange:
            return "The selected correlation does not support the entered Reynolds and Prandtl numbers."
        }
    }
}
