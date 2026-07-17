import Foundation

enum ClausiusClapeyronEstimatorError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveTemperature
    case nonPositivePressure
    case nonPositiveLatentHeat
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "Temperatures, pressure and latent heat must be finite."
        case .nonPositiveTemperature:
            return "Reference and target temperatures must be greater than zero kelvin."
        case .nonPositivePressure:
            return "Reference pressure must be greater than zero."
        case .nonPositiveLatentHeat:
            return "Molar latent heat must be greater than zero."
        case .numericalFailure:
            return "The Clausius–Clapeyron calculation did not produce finite positive pressure."
        }
    }
}
