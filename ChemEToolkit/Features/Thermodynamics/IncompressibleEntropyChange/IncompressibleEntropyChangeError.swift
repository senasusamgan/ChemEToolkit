import Foundation

enum IncompressibleEntropyChangeError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case negativeMass
    case nonPositiveHeatCapacity
    case nonPositiveTemperature
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "Mass, heat capacity and temperatures must be finite."
        case .negativeMass:
            return "Mass cannot be negative."
        case .nonPositiveHeatCapacity:
            return "Specific heat capacity must be greater than zero."
        case .nonPositiveTemperature:
            return "Initial and final temperatures must be greater than zero kelvin."
        case .numericalFailure:
            return "The incompressible entropy calculation did not produce finite results."
        }
    }
}
