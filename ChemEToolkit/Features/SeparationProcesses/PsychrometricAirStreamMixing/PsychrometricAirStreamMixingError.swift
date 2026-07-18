import Foundation

    enum PsychrometricAirStreamMixingError:
        Error,
        Equatable,
        LocalizedError {

        case nonFiniteInput
case nonPositiveFlow
case negativeHumidityRatio
case numericalFailure

        var errorDescription: String? {
            switch self {
            case .nonFiniteInput:
        return "Flow, temperature and humidity-ratio inputs must be finite."
    case .nonPositiveFlow:
        return "Both dry-air flow rates must be greater than zero."
    case .negativeHumidityRatio:
        return "Humidity ratios cannot be negative."
    case .numericalFailure:
        return "The humid-air mixing calculation did not produce finite results."
            }
        }
    }
