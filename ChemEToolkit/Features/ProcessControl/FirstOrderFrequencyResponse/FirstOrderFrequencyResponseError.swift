import Foundation

enum FirstOrderFrequencyResponseError: Error, Equatable, LocalizedError {
    case nonFiniteInput
    case zeroProcessGain
    case nonPositiveTimeConstant
    case negativeAngularFrequency
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput: return "All first-order frequency-response inputs must be finite."
        case .zeroProcessGain: return "Process gain cannot be zero because logarithmic magnitude is undefined."
        case .nonPositiveTimeConstant: return "Time constant must be greater than zero."
        case .negativeAngularFrequency: return "Angular frequency cannot be negative."
        case .numericalFailure: return "The first-order frequency-response calculation did not produce finite results."
        }
    }
}
