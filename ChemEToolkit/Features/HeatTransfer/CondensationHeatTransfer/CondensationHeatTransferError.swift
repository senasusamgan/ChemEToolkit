import Foundation

enum CondensationHeatTransferError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveHeatTransferCoefficient
    case nonPositiveArea

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All entered values must be finite numbers."
        case .nonPositiveHeatTransferCoefficient:
            return "Condensation heat-transfer coefficient must be greater than zero."
        case .nonPositiveArea:
            return "Surface area must be greater than zero."
        }
    }
}
