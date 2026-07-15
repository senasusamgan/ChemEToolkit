import Foundation

enum ArrheniusThreePointFitError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveTemperatureOrRateConstant
    case duplicateTemperatures
    case nonPositiveActivationEnergy
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All three-point Arrhenius inputs must be finite."
        case .nonPositiveTemperatureOrRateConstant:
            return "Temperatures and rate constants must be greater than zero."
        case .duplicateTemperatures:
            return "All three temperatures must be distinct."
        case .nonPositiveActivationEnergy:
            return "The fitted data imply a non-positive activation energy."
        case .numericalFailure:
            return "The three-point Arrhenius fit did not produce finite physical results."
        }
    }
}
