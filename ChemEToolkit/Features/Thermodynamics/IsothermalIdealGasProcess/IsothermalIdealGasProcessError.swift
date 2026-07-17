import Foundation

enum IsothermalIdealGasProcessError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case negativeAmount
    case nonPositiveTemperature
    case nonPositivePressure
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "Amount, temperature and pressures must be finite."
        case .negativeAmount:
            return "Chemical amount cannot be negative."
        case .nonPositiveTemperature:
            return "Temperature must be greater than zero kelvin."
        case .nonPositivePressure:
            return "Initial and final absolute pressures must be greater than zero."
        case .numericalFailure:
            return "The isothermal-process calculation did not produce finite results."
        }
    }
}
