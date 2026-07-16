import Foundation

enum HeatExchangePFRError: Error, Equatable, LocalizedError {
    case nonFiniteInput
    case nonPositiveFeedOrFactor
    case negativeActivationEnergy
    case nonPositiveTemperature
    case negativeHeatRemovalCoefficient
    case conversionOutOfRange
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All heat-exchange PFR inputs must be finite."
        case .nonPositiveFeedOrFactor:
            return "Inlet concentration, volumetric flow and pre-exponential factor must be greater than zero."
        case .negativeActivationEnergy:
            return "Activation energy cannot be negative."
        case .nonPositiveTemperature:
            return "Inlet, coolant and calculated temperatures must remain greater than zero kelvin."
        case .negativeHeatRemovalCoefficient:
            return "Heat-removal coefficient cannot be negative."
        case .conversionOutOfRange:
            return "Target conversion must satisfy 0 < X_A < 1."
        case .numericalFailure:
            return "The heat-exchange PFR calculation did not produce finite physical results."
        }
    }
}
