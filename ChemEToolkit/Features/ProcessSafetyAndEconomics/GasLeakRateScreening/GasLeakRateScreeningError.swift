import Foundation

enum GasLeakRateScreeningError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case invalidPressure
    case nonPositiveTemperature
    case nonPositiveMolecularWeight
    case invalidHeatCapacityRatio
    case invalidDischargeCoefficient
    case nonPositiveOrificeDiameter
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All gas-leak screening inputs must be finite."
        case .invalidPressure:
            return "Absolute pressures must be positive and upstream pressure must exceed downstream pressure."
        case .nonPositiveTemperature:
            return "Gas temperature must be greater than zero kelvin."
        case .nonPositiveMolecularWeight:
            return "Molecular weight must be greater than zero."
        case .invalidHeatCapacityRatio:
            return "Heat-capacity ratio must be greater than one."
        case .invalidDischargeCoefficient:
            return "Discharge coefficient must satisfy 0 < Cd ≤ 1."
        case .nonPositiveOrificeDiameter:
            return "Orifice diameter must be greater than zero."
        case .numericalFailure:
            return "The gas-leak calculation did not produce finite results."
        }
    }
}
