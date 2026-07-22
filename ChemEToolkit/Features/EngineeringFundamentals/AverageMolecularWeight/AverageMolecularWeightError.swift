import Foundation

enum AverageMolecularWeightError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case negativeFraction
    case zeroFractionSum
    case nonPositiveMolecularWeight
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All fractions and molecular weights must be finite."
        case .negativeFraction:
            return "Composition fractions cannot be negative."
        case .zeroFractionSum:
            return "At least one composition fraction must be positive."
        case .nonPositiveMolecularWeight:
            return "Each molecular weight must be greater than zero."
        case .numericalFailure:
            return "The average molecular-weight calculation did not produce finite results."
        }
    }
}
