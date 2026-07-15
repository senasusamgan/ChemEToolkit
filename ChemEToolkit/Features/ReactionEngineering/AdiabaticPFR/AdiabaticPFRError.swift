import Foundation

enum AdiabaticPFRError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveFeedOrFactor
    case negativeActivationEnergy
    case nonPositiveTemperature
    case conversionOutOfRange
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All adiabatic PFR inputs must be finite."
        case .nonPositiveFeedOrFactor:
            return "Inlet concentration, volumetric flow and pre-exponential factor must be greater than zero."
        case .negativeActivationEnergy:
            return "Activation energy cannot be negative."
        case .nonPositiveTemperature:
            return "Inlet and outlet temperatures must remain greater than zero kelvin."
        case .conversionOutOfRange:
            return "Target conversion must satisfy 0 < X_A < 1."
        case .numericalFailure:
            return "The adiabatic PFR calculation did not produce finite physical results."
        }
    }
}
