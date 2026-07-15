import Foundation

enum ShellAndTubeHeatExchangerError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveHeatTransferRate
    case nonPositiveOverallCoefficient
    case invalidCorrectionFactor
    case nonPositiveTubeDiameter
    case nonPositiveTubeLength
    case nonPositiveTubePassCount
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
            Correction factor must be greater than zero \
            and no greater than one.
            """

        case .nonPositiveTubeDiameter:
            return """
            Tube outer diameter must be greater than zero.
            """

        case .nonPositiveTubeLength:
            return """
            Tube length must be greater than zero.
            """

        case .nonPositiveTubePassCount:
            return """
            Number of tube passes must be greater than zero.
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
            Both counter-flow terminal temperature \
            differences must be greater than zero.
            """
        }
    }
}
