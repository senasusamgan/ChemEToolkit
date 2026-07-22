import Foundation

enum StandardGasFlowConverterError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case negativeFlowRate
    case nonPositivePressure
    case nonPositiveTemperature
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All gas-flow conversion inputs must be finite."
        case .negativeFlowRate:
            return "Actual volumetric flow rate cannot be negative."
        case .nonPositivePressure:
            return "Actual and standard absolute pressures must be greater than zero."
        case .nonPositiveTemperature:
            return "Actual and standard temperatures must be greater than zero kelvin."
        case .numericalFailure:
            return "The standard gas-flow conversion did not produce finite results."
        }
    }
}
