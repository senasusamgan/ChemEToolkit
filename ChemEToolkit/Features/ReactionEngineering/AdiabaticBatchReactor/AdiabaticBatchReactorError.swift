import Foundation

enum AdiabaticBatchReactorError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveConcentrationOrFactor
    case negativeActivationEnergy
    case nonPositiveTemperature
    case conversionOutOfRange
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All adiabatic batch inputs must be finite."
        case .nonPositiveConcentrationOrFactor:
            return "Initial concentration and pre-exponential factor must be greater than zero."
        case .negativeActivationEnergy:
            return "Activation energy cannot be negative."
        case .nonPositiveTemperature:
            return "Initial and target temperatures must remain greater than zero kelvin."
        case .conversionOutOfRange:
            return "Target conversion must satisfy 0 < X_A < 1."
        case .numericalFailure:
            return "The adiabatic batch calculation did not produce finite physical results."
        }
    }
}
