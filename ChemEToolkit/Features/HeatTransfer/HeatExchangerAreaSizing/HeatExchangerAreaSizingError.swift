import Foundation

enum HeatExchangerAreaSizingError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveHeatTransferRate
    case nonPositiveOverallCoefficient
    case invalidCorrectionFactor
    case invalidHotStreamTemperatureOrder
    case invalidColdStreamTemperatureOrder
    case nonPositiveTerminalTemperatureDifference

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return """
            All entered values must be finite numbers.
            """

        case .nonPositiveHeatTransferRate:
            return """
            Required heat-transfer rate must be greater \
            than zero.
            """

        case .nonPositiveOverallCoefficient:
            return """
            Overall heat-transfer coefficient must be \
            greater than zero.
            """

        case .invalidCorrectionFactor:
            return """
            LMTD correction factor must be greater than \
            zero and no greater than one.
            """

        case .invalidHotStreamTemperatureOrder:
            return """
            Hot-stream inlet temperature cannot be lower \
            than its outlet temperature.
            """

        case .invalidColdStreamTemperatureOrder:
            return """
            Cold-stream outlet temperature cannot be lower \
            than its inlet temperature.
            """

        case .nonPositiveTerminalTemperatureDifference:
            return """
            Both terminal temperature differences must be \
            greater than zero.
            """
        }
    }
}
