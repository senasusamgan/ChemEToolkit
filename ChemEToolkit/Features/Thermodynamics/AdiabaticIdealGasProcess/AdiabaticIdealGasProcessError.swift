import Foundation

enum AdiabaticIdealGasProcessError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveTemperature
    case nonPositivePressure
    case invalidHeatCapacityRatio
    case nonPositiveGasConstant
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "Temperature, pressures, heat-capacity ratio and gas constant must be finite."
        case .nonPositiveTemperature:
            return "Initial temperature must be greater than zero kelvin."
        case .nonPositivePressure:
            return "Initial and final absolute pressures must be greater than zero."
        case .invalidHeatCapacityRatio:
            return "Heat-capacity ratio must be greater than one."
        case .nonPositiveGasConstant:
            return "Specific gas constant must be greater than zero."
        case .numericalFailure:
            return "The adiabatic-process calculation did not produce finite results."
        }
    }
}
