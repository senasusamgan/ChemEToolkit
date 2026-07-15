import Foundation

enum OverallHeatTransferCoefficientError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveHotSideCoefficient
    case nonPositiveColdSideCoefficient
    case nonPositiveWallConductivity
    case nonPositiveWallThickness
    case negativeHotSideFoulingResistance
    case negativeColdSideFoulingResistance

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return """
            All entered values must be finite numbers.
            """

        case .nonPositiveHotSideCoefficient:
            return """
            Hot-side heat-transfer coefficient must be \
            greater than zero.
            """

        case .nonPositiveColdSideCoefficient:
            return """
            Cold-side heat-transfer coefficient must be \
            greater than zero.
            """

        case .nonPositiveWallConductivity:
            return """
            Wall thermal conductivity must be greater \
            than zero.
            """

        case .nonPositiveWallThickness:
            return """
            Wall thickness must be greater than zero.
            """

        case .negativeHotSideFoulingResistance:
            return """
            Hot-side fouling resistance cannot be \
            negative.
            """

        case .negativeColdSideFoulingResistance:
            return """
            Cold-side fouling resistance cannot be \
            negative.
            """
        }
    }
}
