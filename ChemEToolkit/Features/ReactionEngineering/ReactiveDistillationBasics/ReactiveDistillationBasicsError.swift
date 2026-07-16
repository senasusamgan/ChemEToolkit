import Foundation

enum ReactiveDistillationBasicsError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case invalidInitialMoles
    case nonPositiveEquilibriumConstant
    case removalFractionOutOfRange
    case invalidStageCount
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput: return "All reactive-distillation inputs must be finite."
        case .invalidInitialMoles: return "Initial moles A must be positive and initial moles B cannot be negative."
        case .nonPositiveEquilibriumConstant: return "Equilibrium constant must be greater than zero."
        case .removalFractionOutOfRange: return "Product-removal fraction must satisfy 0 ≤ f < 1."
        case .invalidStageCount: return "Number of equilibrium stages must be a whole number from 1 through 1000."
        case .numericalFailure: return "The reactive-distillation calculation did not produce finite physical results."
        }
    }
}
