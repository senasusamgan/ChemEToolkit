import Foundation

enum InterphaseEquilibriumDrivingForcesError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveEquilibriumSlope
    case moleFractionOutOfRange
    case equilibriumCompositionOutOfRange

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All inputs must be finite."

        case .nonPositiveEquilibriumSlope:
            return """
            The slope of the linear equilibrium relation \
            must be greater than zero.
            """

        case .moleFractionOutOfRange:
            return """
            Bulk and interface mole fractions must lie \
            between zero and one.
            """

        case .equilibriumCompositionOutOfRange:
            return """
            The selected linear equilibrium relation predicts \
            a mole fraction outside the physical range from zero to one.
            """
        }
    }
}
