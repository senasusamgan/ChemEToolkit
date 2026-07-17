import Foundation

enum LiquidControlValveSizingError: Error, Equatable, LocalizedError {
    case nonFiniteInput
    case negativeFlowRate
    case nonPositivePressureDrop
    case nonPositiveDensity
    case nonPositiveInstalledKv
    case invalidSafetyFactor
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All liquid control-valve inputs must be finite."
        case .negativeFlowRate:
            return "Liquid flow rate cannot be negative."
        case .nonPositivePressureDrop:
            return "Valve pressure drop must be greater than zero."
        case .nonPositiveDensity:
            return "Liquid density must be greater than zero."
        case .nonPositiveInstalledKv:
            return "Installed valve Kv must be greater than zero."
        case .invalidSafetyFactor:
            return "Design safety factor must be at least one."
        case .numericalFailure:
            return "The liquid valve-sizing calculation did not produce finite results."
        }
    }
}
