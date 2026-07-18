import Foundation

    enum RelativeHumidityHumidificationError:
        Error,
        Equatable,
        LocalizedError {

        case nonFiniteInput
case nonPositiveFlowOrPressure
case invalidRelativeHumidity
case outletBelowInlet
case vaporPressureNotBelowTotal
case numericalFailure

        var errorDescription: String? {
            switch self {
            case .nonFiniteInput:
        return "Flow, temperature, pressure and relative humidities must be finite."
    case .nonPositiveFlowOrPressure:
        return "Dry-air flow and total pressure must be greater than zero."
    case .invalidRelativeHumidity:
        return "Relative humidities must be greater than zero and below 100%."
    case .outletBelowInlet:
        return "Outlet relative humidity must exceed inlet relative humidity."
    case .vaporPressureNotBelowTotal:
        return "The calculated vapor pressure must remain below total pressure."
    case .numericalFailure:
        return "The relative-humidity humidification calculation did not produce finite results."
            }
        }
    }
