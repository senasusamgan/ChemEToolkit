import Foundation

enum TwoFilmTheoryError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveProperty
    case moleFractionOutOfRange
    case interfaceCompositionOutOfRange

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All inputs must be finite."

        case .nonPositiveProperty:
            return """
            Individual coefficients, equilibrium slope \
            and interfacial area must be greater than zero.
            """

        case .moleFractionOutOfRange:
            return """
            Bulk gas and liquid mole fractions must lie \
            between zero and one.
            """

        case .interfaceCompositionOutOfRange:
            return """
            The calculated interface composition lies outside \
            the physical mole-fraction range from zero to one.
            """
        }
    }
}
