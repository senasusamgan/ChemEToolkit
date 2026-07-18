import Foundation

enum BatchSettlingAreaEstimateError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveFlowOrVelocity
    case invalidSafetyFactor
    case nonPositiveAspectRatio
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "Flow, settling velocity, safety factor and aspect ratio must be finite."
        case .nonPositiveFlowOrVelocity:
            return "Slurry flow and settling velocity must be greater than zero."
        case .invalidSafetyFactor:
            return "Hydraulic safety factor must be at least one."
        case .nonPositiveAspectRatio:
            return "Tank depth-to-diameter ratio must be greater than zero."
        case .numericalFailure:
            return "The settling-area calculation did not produce finite results."
        }
    }
}
