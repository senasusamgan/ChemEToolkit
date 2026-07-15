import Foundation

enum ActivationEnergyTwoPointError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveTemperatureOrRateConstant
    case equalTemperatures
    case nonPositiveActivationEnergy
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All two-point Arrhenius inputs must be finite."
        case .nonPositiveTemperatureOrRateConstant:
            return "Temperatures and rate constants must be greater than zero."
        case .equalTemperatures:
            return "The two temperatures must be different."
        case .nonPositiveActivationEnergy:
            return "The entered data imply a non-positive activation energy."
        case .numericalFailure:
            return "The activation-energy calculation did not produce finite physical results."
        }
    }
}
