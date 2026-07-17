import Foundation

enum InternalEnergyChangeCalculatorError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case negativeMass
    case nonPositiveHeatCapacity
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "Mass, heat capacity and temperatures must be finite."
        case .negativeMass:
            return "Mass cannot be negative."
        case .nonPositiveHeatCapacity:
            return "Specific heat at constant volume must be greater than zero."
        case .numericalFailure:
            return "The internal-energy calculation did not produce finite results."
        }
    }
}
