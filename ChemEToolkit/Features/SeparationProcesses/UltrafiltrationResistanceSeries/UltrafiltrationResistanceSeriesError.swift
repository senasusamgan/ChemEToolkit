import Foundation

enum UltrafiltrationResistanceSeriesError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositivePressureViscosityOrFlow
    case invalidResistance
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "Pressure, viscosity, resistances and flow must be finite."
        case .nonPositivePressureViscosityOrFlow:
            return "Pressure, viscosity and target permeate flow must be greater than zero."
        case .invalidResistance:
            return "Membrane resistance must be positive and fouling resistance cannot be negative."
        case .numericalFailure:
            return "The ultrafiltration calculation did not produce finite results."
        }
    }
}
