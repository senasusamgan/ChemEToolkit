import Foundation

enum ThermalRadiationError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case invalidEmissivity
    case nonPositiveArea
    case surfaceTemperatureBelowAbsoluteZero
    case surroundingsTemperatureBelowAbsoluteZero

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return """
            All entered values must be finite numbers.
            """

        case .invalidEmissivity:
            return """
            Emissivity must be between zero and one.
            """

        case .nonPositiveArea:
            return """
            Radiating surface area must be greater than zero.
            """

        case .surfaceTemperatureBelowAbsoluteZero:
            return """
            Surface temperature cannot be below absolute zero.
            """

        case .surroundingsTemperatureBelowAbsoluteZero:
            return """
            Surroundings temperature cannot be below absolute zero.
            """
        }
    }
}
