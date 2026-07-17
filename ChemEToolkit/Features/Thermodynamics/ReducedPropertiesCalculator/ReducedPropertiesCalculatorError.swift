import Foundation

enum ReducedPropertiesCalculatorError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveTemperature
    case nonPositivePressure
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "Temperatures and pressures must be finite."
        case .nonPositiveTemperature:
            return "Actual and critical temperatures must be greater than zero kelvin."
        case .nonPositivePressure:
            return "Actual and critical pressures must be greater than zero."
        case .numericalFailure:
            return "The reduced-property calculation did not produce finite results."
        }
    }
}
