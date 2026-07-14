import Foundation

enum ConvectionHeatTransferError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveHeatTransferCoefficient
    case nonPositiveArea

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

        case .nonPositiveArea:
            return """
            Heat-transfer area must be greater than zero.
            """
        }
    }
}
