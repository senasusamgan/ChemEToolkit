import Foundation
enum MichaelisMentenReactorError: Error, Equatable, LocalizedError {
    case nonFiniteInput
    case nonPositiveFeedCondition
    case invalidKineticParameter
    case conversionOutOfRange
    case numericalFailure
    var errorDescription: String? {
        switch self {
        case .nonFiniteInput: return "All Michaelis–Menten reactor inputs must be finite."
        case .nonPositiveFeedCondition: return "Inlet concentration and flow rate must be greater than zero."
        case .invalidKineticParameter: return "Maximum rate must be positive and the Michaelis constant cannot be negative."
        case .conversionOutOfRange: return "Target conversion must satisfy 0 < X < 1."
        case .numericalFailure: return "The Michaelis–Menten reactor calculation failed."
        }
    }
}
