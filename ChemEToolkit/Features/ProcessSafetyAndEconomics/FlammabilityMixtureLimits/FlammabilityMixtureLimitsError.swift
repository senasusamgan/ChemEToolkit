import Foundation

enum FlammabilityMixtureLimitsError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case negativeComponentFraction
    case zeroCombustibleFraction
    case invalidFlammabilityLimit
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All flammability-mixture inputs must be finite."
        case .negativeComponentFraction:
            return "Component fractions cannot be negative."
        case .zeroCombustibleFraction:
            return "At least one combustible component fraction must be greater than zero."
        case .invalidFlammabilityLimit:
            return "Each active component must satisfy 0 < LFL < UFL."
        case .numericalFailure:
            return "The mixture flammability-limit calculation did not produce finite results."
        }
    }
}
