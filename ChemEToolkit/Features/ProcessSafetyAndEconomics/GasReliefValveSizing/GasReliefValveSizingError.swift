import Foundation

enum GasReliefValveSizingError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveFlowRate
    case invalidPressure
    case nonPositiveTemperature
    case nonPositiveMolecularWeight
    case invalidHeatCapacityRatio
    case invalidDischargeCoefficient
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All gas relief-valve sizing inputs must be finite."
        case .nonPositiveFlowRate:
            return "Required mass flow rate must be greater than zero."
        case .invalidPressure:
            return "Absolute pressures must be positive and upstream pressure must exceed back pressure."
        case .nonPositiveTemperature:
            return "Relieving temperature must be greater than zero kelvin."
        case .nonPositiveMolecularWeight:
            return "Molecular weight must be greater than zero."
        case .invalidHeatCapacityRatio:
            return "Heat-capacity ratio must be greater than one."
        case .invalidDischargeCoefficient:
            return "Discharge coefficient must satisfy 0 < Cd ≤ 1."
        case .numericalFailure:
            return "The gas relief-valve sizing calculation did not produce finite results."
        }
    }
}
