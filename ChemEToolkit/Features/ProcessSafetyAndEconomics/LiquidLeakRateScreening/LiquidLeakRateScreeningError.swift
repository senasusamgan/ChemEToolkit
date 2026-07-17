import Foundation

enum LiquidLeakRateScreeningError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveDensity
    case invalidPressure
    case invalidDischargeCoefficient
    case nonPositiveOrificeDiameter
    case negativeInventoryVolume
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All liquid-leak screening inputs must be finite."
        case .nonPositiveDensity:
            return "Liquid density must be greater than zero."
        case .invalidPressure:
            return "Absolute pressures must be positive and upstream pressure must exceed downstream pressure."
        case .invalidDischargeCoefficient:
            return "Discharge coefficient must satisfy 0 < Cd ≤ 1."
        case .nonPositiveOrificeDiameter:
            return "Orifice diameter must be greater than zero."
        case .negativeInventoryVolume:
            return "Liquid inventory volume cannot be negative."
        case .numericalFailure:
            return "The liquid-leak calculation did not produce finite results."
        }
    }
}
