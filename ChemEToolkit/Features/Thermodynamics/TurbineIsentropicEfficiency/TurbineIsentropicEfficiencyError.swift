import Foundation

enum TurbineIsentropicEfficiencyError: Error, Equatable, LocalizedError {
    case nonFiniteInput
    case nonPositiveMassFlow
    case invalidIsentropicDrop
    case invalidActualOutlet
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "Flow rate and enthalpies must be finite."
        case .nonPositiveMassFlow:
            return "Mass flow rate must be greater than zero."
        case .invalidIsentropicDrop:
            return "Isentropic outlet enthalpy must be lower than inlet enthalpy."
        case .invalidActualOutlet:
            return "Actual outlet enthalpy must lie between isentropic outlet and inlet enthalpy."
        case .numericalFailure:
            return "The turbine-efficiency calculation did not produce finite results."
        }
    }
}
