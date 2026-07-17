import Foundation

enum LiquidReliefValveSizingError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveFlowRate
    case nonPositiveDensity
    case invalidPressure
    case invalidDischargeCoefficient
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All liquid relief-valve sizing inputs must be finite."
        case .nonPositiveFlowRate:
            return "Required mass flow rate must be greater than zero."
        case .nonPositiveDensity:
            return "Liquid density must be greater than zero."
        case .invalidPressure:
            return "Absolute pressures must be positive and inlet pressure must exceed back pressure."
        case .invalidDischargeCoefficient:
            return "Discharge coefficient must satisfy 0 < Cd ≤ 1."
        case .numericalFailure:
            return "The liquid relief-valve sizing calculation did not produce finite results."
        }
    }
}
