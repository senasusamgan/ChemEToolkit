import Foundation

enum MixtureDensityCalculatorError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case negativeMass
    case nonPositiveDensity
    case zeroTotalMass
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All component masses and densities must be finite."
        case .negativeMass:
            return "Component masses cannot be negative."
        case .nonPositiveDensity:
            return "Each component density must be greater than zero."
        case .zeroTotalMass:
            return "At least one component mass must be positive."
        case .numericalFailure:
            return "The mixture-density calculation did not produce finite results."
        }
    }
}
