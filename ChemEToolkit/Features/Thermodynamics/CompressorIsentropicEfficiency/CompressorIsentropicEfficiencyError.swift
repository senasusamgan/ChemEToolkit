import Foundation

enum CompressorIsentropicEfficiencyError: Error, Equatable, LocalizedError {
    case nonFiniteInput
    case nonPositiveMassFlow
    case invalidIsentropicRise
    case invalidActualOutlet
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "Flow rate and enthalpies must be finite."
        case .nonPositiveMassFlow:
            return "Mass flow rate must be greater than zero."
        case .invalidIsentropicRise:
            return "Isentropic outlet enthalpy must exceed inlet enthalpy."
        case .invalidActualOutlet:
            return "Actual outlet enthalpy must be at least the isentropic outlet enthalpy."
        case .numericalFailure:
            return "The compressor-efficiency calculation did not produce finite results."
        }
    }
}
