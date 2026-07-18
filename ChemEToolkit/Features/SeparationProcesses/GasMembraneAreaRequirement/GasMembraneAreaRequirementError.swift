import Foundation

enum GasMembraneAreaRequirementError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveFlowOrPermeance
    case invalidPressureDifference
    case invalidUtilization
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "Flow, permeance, pressures and utilization must be finite."
        case .nonPositiveFlowOrPermeance:
            return "Permeate component flow and permeance must be greater than zero."
        case .invalidPressureDifference:
            return "Feed-side partial pressure must exceed nonnegative permeate-side partial pressure."
        case .invalidUtilization:
            return "Module utilization must be greater than zero and no greater than one."
        case .numericalFailure:
            return "The membrane-area calculation did not produce finite results."
        }
    }
}
