import Foundation

enum PlaneWallConductionError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveThermalConductivity
    case nonPositiveArea
    case nonPositiveWallThickness
    case invalidTemperatureOrder

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return """
            All entered values must be finite numbers.
            """

        case .nonPositiveThermalConductivity:
            return """
            Thermal conductivity must be greater than zero.
            """

        case .nonPositiveArea:
            return """
            Wall area must be greater than zero.
            """

        case .nonPositiveWallThickness:
            return """
            Wall thickness must be greater than zero.
            """

        case .invalidTemperatureOrder:
            return """
            Hot-side temperature cannot be lower than \
            cold-side temperature.
            """
        }
    }
}
