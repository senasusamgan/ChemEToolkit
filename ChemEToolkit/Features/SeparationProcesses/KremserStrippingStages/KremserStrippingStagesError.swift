import Foundation

enum KremserStrippingStagesError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveStrippingFactor
    case invalidRemovalFraction
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "Stripping factor and target removal must be finite."
        case .nonPositiveStrippingFactor:
            return "The stripping factor must be greater than zero."
        case .invalidRemovalFraction:
            return "Target removal must be greater than zero and less than one."
        case .numericalFailure:
            return "The Kremser stripping-stage calculation did not produce finite results."
        }
    }
}
