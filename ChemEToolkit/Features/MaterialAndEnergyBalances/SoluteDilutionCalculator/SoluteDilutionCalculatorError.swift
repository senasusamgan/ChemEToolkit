import Foundation

enum SoluteDilutionCalculatorError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveInitialMass
    case fractionOutsideRange
    case invalidDilutionTarget
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "Initial mass and concentration fractions must be finite."
        case .nonPositiveInitialMass:
            return "Initial solution mass must be greater than zero."
        case .fractionOutsideRange:
            return "Initial and target solute fractions must lie between zero and one."
        case .invalidDilutionTarget:
            return "Target solute fraction must be positive and lower than or equal to the initial fraction."
        case .numericalFailure:
            return "The dilution calculation did not produce finite results."
        }
    }
}
