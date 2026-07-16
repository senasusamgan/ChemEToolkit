import Foundation

enum SemibatchReactorError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveInitialVolume
    case nonPositiveInitialMolesB
    case nonPositiveFeedCondition
    case nonPositiveRateConstant
    case nonPositiveOperationTime
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All semibatch-reactor inputs must be finite."
        case .nonPositiveInitialVolume:
            return "Initial liquid volume must be greater than zero."
        case .nonPositiveInitialMolesB:
            return "Initial moles of B must be greater than zero."
        case .nonPositiveFeedCondition:
            return "Feed concentration and feed volumetric flow rate must be greater than zero."
        case .nonPositiveRateConstant:
            return "Second-order rate constant must be greater than zero."
        case .nonPositiveOperationTime:
            return "Operation time must be greater than zero."
        case .numericalFailure:
            return "The semibatch-reactor integration did not produce finite physical results."
        }
    }
}
