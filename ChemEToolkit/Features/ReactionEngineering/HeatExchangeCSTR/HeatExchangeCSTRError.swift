import Foundation

enum HeatExchangeCSTRError: Error, Equatable, LocalizedError {
    case nonFiniteInput
    case nonPositiveFeedOrFactor
    case negativeActivationEnergy
    case nonPositiveTemperature
    case negativeHeatRemovalNumber
    case conversionOutOfRange
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All heat-exchange CSTR inputs must be finite."
        case .nonPositiveFeedOrFactor:
            return "Inlet concentration, volumetric flow and pre-exponential factor must be greater than zero."
        case .negativeActivationEnergy:
            return "Activation energy cannot be negative."
        case .nonPositiveTemperature:
            return "Inlet, coolant and calculated outlet temperatures must remain greater than zero kelvin."
        case .negativeHeatRemovalNumber:
            return "Heat-removal number cannot be negative."
        case .conversionOutOfRange:
            return "Target conversion must satisfy 0 < X_A < 1."
        case .numericalFailure:
            return "The heat-exchange CSTR calculation did not produce finite physical results."
        }
    }
}
