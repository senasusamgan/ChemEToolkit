import Foundation

enum FinHeatTransferError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveHeatTransferCoefficient
    case nonPositiveThermalConductivity
    case nonPositiveFinLength
    case nonPositiveFinWidth
    case nonPositiveFinThickness
    case invalidTemperatureOrder

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return """
            All entered values must be finite numbers.
            """

        case .nonPositiveHeatTransferCoefficient:
            return """
            Heat-transfer coefficient must be greater \
            than zero.
            """

        case .nonPositiveThermalConductivity:
            return """
            Fin thermal conductivity must be greater \
            than zero.
            """

        case .nonPositiveFinLength:
            return """
            Fin length must be greater than zero.
            """

        case .nonPositiveFinWidth:
            return """
            Fin width must be greater than zero.
            """

        case .nonPositiveFinThickness:
            return """
            Fin thickness must be greater than zero.
            """

        case .invalidTemperatureOrder:
            return """
            Fin-base temperature cannot be lower than \
            ambient temperature.
            """
        }
    }
}
