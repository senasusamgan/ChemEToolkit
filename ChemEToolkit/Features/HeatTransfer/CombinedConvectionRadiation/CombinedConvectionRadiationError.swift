import Foundation

enum CombinedConvectionRadiationError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveHeatTransferCoefficient
    case invalidEmissivity
    case nonPositiveArea
    case surfaceTemperatureBelowAbsoluteZero
    case fluidTemperatureBelowAbsoluteZero
    case surroundingsTemperatureBelowAbsoluteZero

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return """
            All entered values must be finite numbers.
            """

        case .nonPositiveHeatTransferCoefficient:
            return """
            Convective heat-transfer coefficient must be \
            greater than zero.
            """

        case .invalidEmissivity:
            return """
            Emissivity must be between zero and one.
            """

        case .nonPositiveArea:
            return """
            Heat-transfer area must be greater than zero.
            """

        case .surfaceTemperatureBelowAbsoluteZero:
            return """
            Surface temperature cannot be below absolute zero.
            """

        case .fluidTemperatureBelowAbsoluteZero:
            return """
            Fluid temperature cannot be below absolute zero.
            """

        case .surroundingsTemperatureBelowAbsoluteZero:
            return """
            Surroundings temperature cannot be below absolute zero.
            """
        }
    }
}
