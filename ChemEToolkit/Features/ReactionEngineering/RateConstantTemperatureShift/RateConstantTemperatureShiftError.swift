import Foundation

enum RateConstantTemperatureShiftError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveReferenceRateConstant
    case nonPositiveTemperature
    case negativeActivationEnergy
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All temperature-shift inputs must be finite."
        case .nonPositiveReferenceRateConstant:
            return "Reference rate constant must be greater than zero."
        case .nonPositiveTemperature:
            return "Both temperatures must be greater than zero kelvin."
        case .negativeActivationEnergy:
            return "Activation energy cannot be negative."
        case .numericalFailure:
            return "The temperature-shift calculation did not produce finite physical results."
        }
    }
}
