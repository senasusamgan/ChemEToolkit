import Foundation

enum HumidificationPsychrometricsError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveDryAirFlow
    case temperatureOutsideCorrelationRange
    case nonPositivePressure
    case relativeHumidityOutOfRange
    case pressureAtOrBelowSaturation
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All psychrometric inputs must be finite."

        case .nonPositiveDryAirFlow:
            return "Dry-air mass flow rate must be greater than zero."

        case .temperatureOutsideCorrelationRange:
            return """
            Dry-bulb temperature must remain between −40 °C and 60 °C \
            for the implemented Magnus saturation-pressure correlation.
            """

        case .nonPositivePressure:
            return "Total pressure must be greater than zero."

        case .relativeHumidityOutOfRange:
            return "Relative humidity must lie between zero and one."

        case .pressureAtOrBelowSaturation:
            return """
            Total pressure must exceed the saturation vapor pressure \
            at the selected dry-bulb temperature.
            """

        case .numericalFailure:
            return "The psychrometric calculation did not produce finite physical results."
        }
    }
}
