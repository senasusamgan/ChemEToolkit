import Foundation

enum SolidsWashingBalanceError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveInitialSolution
    case fractionOutsideRange
    case negativeWashSolvent
    case invalidFinalRetainedMass
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "Retained solution, concentration and wash-solvent inputs must be finite."
        case .nonPositiveInitialSolution:
            return "Initial retained solution mass must be greater than zero."
        case .fractionOutsideRange:
            return "Initial solute mass fraction must lie between zero and one."
        case .negativeWashSolvent:
            return "Wash-solvent mass cannot be negative."
        case .invalidFinalRetainedMass:
            return "Final retained solution mass must be nonnegative and cannot exceed total mixed liquid mass."
        case .numericalFailure:
            return "The solids-washing balance did not produce finite results."
        }
    }
}
