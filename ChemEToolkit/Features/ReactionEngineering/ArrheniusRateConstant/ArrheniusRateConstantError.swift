import Foundation

enum ArrheniusRateConstantError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositivePreExponentialFactor
    case negativeActivationEnergy
    case nonPositiveTemperature
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All Arrhenius inputs must be finite."
        case .nonPositivePreExponentialFactor:
            return "Pre-exponential factor must be greater than zero."
        case .negativeActivationEnergy:
            return "Activation energy cannot be negative."
        case .nonPositiveTemperature:
            return "Absolute temperature must be greater than zero kelvin."
        case .numericalFailure:
            return "The Arrhenius calculation did not produce finite physical results."
        }
    }
}
