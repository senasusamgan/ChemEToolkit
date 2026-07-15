import Foundation

enum CatalystWeightFromRateDataError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveFeedRate
    case invalidConversionInterval
    case nonPositiveInverseRate
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All catalyst-weight inputs must be finite."
        case .nonPositiveFeedRate:
            return "Inlet molar flow rate must be greater than zero."
        case .invalidConversionInterval:
            return "Conversions must satisfy 0 ≤ X₀ < X₁ ≤ 1."
        case .nonPositiveInverseRate:
            return "All entered values of 1/(−r′A) must be greater than zero."
        case .numericalFailure:
            return "The catalyst-weight calculation did not produce finite physical results."
        }
    }
}
