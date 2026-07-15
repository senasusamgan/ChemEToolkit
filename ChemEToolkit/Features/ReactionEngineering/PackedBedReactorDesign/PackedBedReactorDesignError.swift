import Foundation

enum PackedBedReactorDesignError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveFeed
    case nonPositiveRateConstant
    case conversionOutOfRange
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All packed-bed reactor inputs must be finite."
        case .nonPositiveFeed:
            return "Inlet concentration and volumetric flow rate must be greater than zero."
        case .nonPositiveRateConstant:
            return "Mass-specific first-order rate constant must be greater than zero."
        case .conversionOutOfRange:
            return "Target conversion must satisfy 0 < X_A < 1."
        case .numericalFailure:
            return "The packed-bed reactor design did not produce finite physical results."
        }
    }
}
