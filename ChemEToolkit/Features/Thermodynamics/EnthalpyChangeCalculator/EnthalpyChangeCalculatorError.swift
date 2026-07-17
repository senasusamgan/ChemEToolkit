import Foundation

enum EnthalpyChangeCalculatorError:
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
            return "Specific heat at constant pressure must be greater than zero."
        case .numericalFailure:
            return "The enthalpy-change calculation did not produce finite results."
        }
    }
}
