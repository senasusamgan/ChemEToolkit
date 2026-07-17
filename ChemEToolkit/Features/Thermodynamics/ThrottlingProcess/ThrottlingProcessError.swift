import Foundation

enum ThrottlingProcessError: Error, Equatable, LocalizedError {
    case nonFiniteInput
    case nonPositiveTemperature
    case nonPositivePressure
    case invalidPressureDrop
    case nonPositiveOutletTemperature
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "Temperature, pressures and Joule–Thomson coefficient must be finite."
        case .nonPositiveTemperature:
            return "Inlet temperature must be greater than zero kelvin."
        case .nonPositivePressure:
            return "Inlet and outlet absolute pressures must be greater than zero."
        case .invalidPressureDrop:
            return "Outlet pressure must be lower than inlet pressure for throttling."
        case .nonPositiveOutletTemperature:
            return "The predicted outlet temperature is not physically positive."
        case .numericalFailure:
            return "The throttling calculation did not produce finite results."
        }
    }
}
