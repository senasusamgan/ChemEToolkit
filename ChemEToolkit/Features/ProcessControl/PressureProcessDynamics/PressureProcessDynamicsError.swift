import Foundation

enum PressureProcessDynamicsError: Error, Equatable, LocalizedError {
    case nonFiniteInput
    case nonPositiveVesselProperty
    case invalidPressureLimit
    case negativeEvaluationTime
    case nonPhysicalSteadyPressure
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput: return "All pressure-process inputs must be finite."
        case .nonPositiveVesselProperty: return "Vessel volume, gas temperature and pressure-flow resistance must be greater than zero."
        case .invalidPressureLimit: return "Initial pressure must be positive and maximum allowable pressure must exceed the initial pressure."
        case .negativeEvaluationTime: return "Evaluation time cannot be negative."
        case .nonPhysicalSteadyPressure: return "The linear model predicts a nonpositive steady pressure."
        case .numericalFailure: return "The pressure-process calculation did not produce finite physical results."
        }
    }
}
