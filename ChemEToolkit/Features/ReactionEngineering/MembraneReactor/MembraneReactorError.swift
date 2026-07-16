import Foundation

enum MembraneReactorError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case invalidFeedConcentration
    case invalidRateConstant
    case nonPositiveSpaceTime
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput: return "All membrane-reactor inputs must be finite."
        case .invalidFeedConcentration: return "Inlet concentration A must be positive and inlet concentration B cannot be negative."
        case .invalidRateConstant: return "Forward rate must be positive; reverse and membrane-removal constants cannot be negative."
        case .nonPositiveSpaceTime: return "Space time must be greater than zero."
        case .numericalFailure: return "The membrane-reactor integration did not produce finite physical results."
        }
    }
}
