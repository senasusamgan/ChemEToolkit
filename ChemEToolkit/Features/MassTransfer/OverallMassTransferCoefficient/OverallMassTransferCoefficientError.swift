import Foundation

enum OverallMassTransferCoefficientError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveProperty
    case moleFractionOutOfRange
    case equilibriumCompositionOutOfRange

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

        case .equilibriumCompositionOutOfRange:
            return """
            The selected equilibrium relation predicts a bulk \
            equilibrium composition outside the physical range.
            """
        }
    }
}
