import Foundation

enum HumidifierWaterBalanceError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveDryGasFlow
    case negativeHumidityRatio
    case invalidHumidificationTarget
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "Dry-gas flow and humidity ratios must be finite."
        case .nonPositiveDryGasFlow:
            return "Dry-gas mass flow must be greater than zero."
        case .negativeHumidityRatio:
            return "Humidity ratios cannot be negative."
        case .invalidHumidificationTarget:
            return "Outlet humidity ratio cannot be lower than inlet humidity ratio."
        case .numericalFailure:
            return "The humidifier water balance did not produce finite results."
        }
    }
}
