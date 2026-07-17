import Foundation

enum ProcessControlStrategyComparisonError: Error, Equatable, LocalizedError {
    case nonFiniteInput
    case negativeDeadTimeRatio
    case fractionOutsideRange
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All process-control comparison inputs must be finite."
        case .negativeDeadTimeRatio:
            return "Dead-time-to-time-constant ratio cannot be negative."
        case .fractionOutsideRange:
            return "All quality, interaction, confidence and nonlinearity inputs must be between zero and one."
        case .numericalFailure:
            return "The process-control comparison did not produce finite scores."
        }
    }
}
