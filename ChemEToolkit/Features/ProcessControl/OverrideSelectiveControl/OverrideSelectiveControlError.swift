import Foundation

enum OverrideSelectiveControlError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case invalidFinalOutputLimits
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All override-control outputs and limits must be finite."
        case .invalidFinalOutputLimits:
            return "Minimum final output must be less than maximum final output."
        case .numericalFailure:
            return "The override-control calculation did not produce finite results."
        }
    }
}
