import Foundation

enum ThermalResistanceNetworkError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case noResistances
    case nonPositiveResistance(branchNumber: Int)
    case invalidTemperatureOrder

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All entered values must be finite numbers."

        case .noResistances:
            return "At least one thermal resistance is required."

        case let .nonPositiveResistance(branchNumber):
            return "Resistance \(branchNumber) must be greater than zero."

        case .invalidTemperatureOrder:
            return "Hot-side temperature cannot be lower than cold-side temperature."
        }
    }
}
