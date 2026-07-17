import Foundation

enum KremserAbsorptionStagesError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveAbsorptionFactor
    case invalidRemovalFraction
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "Absorption factor and target removal must be finite."
        case .nonPositiveAbsorptionFactor:
            return "The absorption factor must be greater than zero."
        case .invalidRemovalFraction:
            return "Target removal must be greater than zero and less than one."
        case .numericalFailure:
            return "The Kremser absorption-stage calculation did not produce finite results."
        }
    }
}
