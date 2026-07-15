import Foundation

enum FourierNumberError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveThermalDiffusivity
    case negativeElapsedTime
    case nonPositiveCharacteristicLength

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All entered values must be finite numbers."

        case .nonPositiveThermalDiffusivity:
            return "Thermal diffusivity must be greater than zero."

        case .negativeElapsedTime:
            return "Elapsed time cannot be negative."

        case .nonPositiveCharacteristicLength:
            return "Characteristic length must be greater than zero."
        }
    }
}
