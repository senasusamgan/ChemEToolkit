import Foundation

enum SecondOrderFrequencyResponseError: Error, Equatable, LocalizedError {
    case nonFiniteInput
    case zeroProcessGain
    case nonPositiveNaturalFrequency
    case nonPositiveDampingRatio
    case negativeAngularFrequency
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput: return "All second-order frequency-response inputs must be finite."
        case .zeroProcessGain: return "Process gain cannot be zero because logarithmic magnitude is undefined."
        case .nonPositiveNaturalFrequency: return "Natural frequency must be greater than zero."
        case .nonPositiveDampingRatio: return "Damping ratio must be greater than zero."
        case .negativeAngularFrequency: return "Angular frequency cannot be negative."
        case .numericalFailure: return "The second-order frequency-response calculation did not produce finite results."
        }
    }
}
