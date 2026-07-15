import Foundation

enum CriticalRadiusOfInsulationError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveThermalConductivity
    case nonPositiveHeatTransferCoefficient
    case nonPositiveInnerRadius
    case invalidOuterRadius
    case nonPositiveCylinderLength
    case invalidTemperatureOrder

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return """
            All entered values must be finite numbers.
            """

        case .nonPositiveThermalConductivity:
            return """
            Insulation thermal conductivity must be \
            greater than zero.
            """

        case .nonPositiveHeatTransferCoefficient:
            return """
            External heat-transfer coefficient must be \
            greater than zero.
            """

        case .nonPositiveInnerRadius:
            return """
            Inner radius must be greater than zero.
            """

        case .invalidOuterRadius:
            return """
            Outer radius must be greater than the inner \
            radius.
            """

        case .nonPositiveCylinderLength:
            return """
            Cylinder length must be greater than zero.
            """

        case .invalidTemperatureOrder:
            return """
            Inner-surface temperature cannot be lower than \
            ambient temperature.
            """
        }
    }
}
