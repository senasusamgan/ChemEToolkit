import Foundation

    enum PsychrometricAirEnthalpyError:
        Error,
        Equatable,
        LocalizedError {

        case nonFiniteInput
case negativeHumidityRatio
case nonPositiveProperty
case numericalFailure

        var errorDescription: String? {
            switch self {
            case .nonFiniteInput:
        return "Temperature, humidity ratio and heat-capacity inputs must be finite."
    case .negativeHumidityRatio:
        return "Humidity ratio cannot be negative."
    case .nonPositiveProperty:
        return "Heat capacities and reference latent heat must be greater than zero."
    case .numericalFailure:
        return "The humid-air enthalpy calculation did not produce finite results."
            }
        }
    }
