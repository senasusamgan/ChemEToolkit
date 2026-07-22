import Foundation

enum PhaseChangeEnergyBalanceError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case negativeMassFlow
    case nonPositiveLatentHeat
    case fractionOutsideRange
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "Flow rate, latent heat and phase-change fraction must be finite."
        case .negativeMassFlow:
            return "Mass flow rate cannot be negative."
        case .nonPositiveLatentHeat:
            return "Latent heat must be greater than zero."
        case .fractionOutsideRange:
            return "Phase-change fraction must lie between zero and one."
        case .numericalFailure:
            return "The phase-change energy balance did not produce finite results."
        }
    }
}
