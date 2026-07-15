import Foundation

enum DimensionlessMassTransferError: Error, Equatable, LocalizedError {
    case nonFiniteInput
    case nonPositiveProperty

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            "All inputs must be finite."
        case .nonPositiveProperty:
            "Density, viscosity, diffusivities, coefficient, and length must be greater than zero."
        }
    }
}
