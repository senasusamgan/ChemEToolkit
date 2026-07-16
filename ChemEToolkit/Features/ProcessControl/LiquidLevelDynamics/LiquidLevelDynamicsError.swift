import Foundation

enum LiquidLevelDynamicsError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveTankProperty
    case invalidLevelLimit
    case negativeEvaluationTime
    case negativePredictedSteadyLevel
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All liquid-level inputs must be finite."
        case .nonPositiveTankProperty:
            return "Tank area and hydraulic resistance must be greater than zero."
        case .invalidLevelLimit:
            return "Initial level must be nonnegative and maximum tank level must exceed the initial level."
        case .negativeEvaluationTime:
            return "Evaluation time cannot be negative."
        case .negativePredictedSteadyLevel:
            return "The linear model predicts a negative steady liquid level; reduce the negative flow step or use a draining-to-empty model."
        case .numericalFailure:
            return "The liquid-level calculation did not produce finite results."
        }
    }
}
