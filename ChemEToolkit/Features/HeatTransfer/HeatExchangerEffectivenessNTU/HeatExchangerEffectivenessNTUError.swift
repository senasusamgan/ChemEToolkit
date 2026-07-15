import Foundation

enum HeatExchangerEffectivenessNTUError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case invalidInletTemperatureOrder
    case nonPositiveHotMassFlowRate
    case nonPositiveColdMassFlowRate
    case nonPositiveHotSpecificHeat
    case nonPositiveColdSpecificHeat
    case nonPositiveOverallCoefficient
    case nonPositiveArea

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return """
            All entered values must be finite numbers.
            """

        case .invalidInletTemperatureOrder:
            return """
            Hot-stream inlet temperature must be greater \
            than the cold-stream inlet temperature.
            """

        case .nonPositiveHotMassFlowRate:
            return """
            Hot-stream mass flow rate must be greater \
            than zero.
            """

        case .nonPositiveColdMassFlowRate:
            return """
            Cold-stream mass flow rate must be greater \
            than zero.
            """

        case .nonPositiveHotSpecificHeat:
            return """
            Hot-stream specific heat must be greater \
            than zero.
            """

        case .nonPositiveColdSpecificHeat:
            return """
            Cold-stream specific heat must be greater \
            than zero.
            """

        case .nonPositiveOverallCoefficient:
            return """
            Overall heat-transfer coefficient must be \
            greater than zero.
            """

        case .nonPositiveArea:
            return """
            Heat-transfer area must be greater than zero.
            """
        }
    }
}
