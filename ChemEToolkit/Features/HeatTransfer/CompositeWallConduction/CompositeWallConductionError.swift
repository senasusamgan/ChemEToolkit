import Foundation

enum CompositeWallConductionError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case noLayers
    case nonPositiveArea
    case nonPositiveThermalConductivity(
        layerNumber: Int
    )
    case nonPositiveThickness(
        layerNumber: Int
    )
    case invalidTemperatureOrder

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return """
            All entered values must be finite numbers.
            """

        case .noLayers:
            return """
            At least one wall layer is required.
            """

        case .nonPositiveArea:
            return """
            Wall area must be greater than zero.
            """

        case let .nonPositiveThermalConductivity(
            layerNumber
        ):
            return """
            Thermal conductivity for layer \
            \(layerNumber) must be greater than zero.
            """

        case let .nonPositiveThickness(
            layerNumber
        ):
            return """
            Thickness for layer \(layerNumber) must be \
            greater than zero.
            """

        case .invalidTemperatureOrder:
            return """
            Hot-side temperature cannot be lower than \
            cold-side temperature.
            """
        }
    }
}
