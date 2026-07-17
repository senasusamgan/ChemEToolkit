import Foundation

enum PumpIsentropicEfficiencyError: Error, Equatable, LocalizedError {
    case nonFiniteInput
    case nonPositiveMassFlow
    case invalidPressureRise
    case nonPositiveSpecificVolume
    case invalidEfficiency
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "Flow, pressures, specific volume and efficiency must be finite."
        case .nonPositiveMassFlow:
            return "Mass flow rate must be greater than zero."
        case .invalidPressureRise:
            return "Outlet pressure must exceed inlet pressure."
        case .nonPositiveSpecificVolume:
            return "Specific volume must be greater than zero."
        case .invalidEfficiency:
            return "Pump isentropic efficiency must be greater than zero and no greater than one."
        case .numericalFailure:
            return "The pump-efficiency calculation did not produce finite results."
        }
    }
}
