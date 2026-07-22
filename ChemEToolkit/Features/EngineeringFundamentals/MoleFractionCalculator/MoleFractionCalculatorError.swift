import Foundation

enum MoleFractionCalculatorError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case negativeMoles
    case zeroTotalMoles
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "Component and other moles must be finite."
        case .negativeMoles:
            return "Mole amounts cannot be negative."
        case .zeroTotalMoles:
            return "Total moles must be greater than zero."
        case .numericalFailure:
            return "The mole-fraction calculation did not produce finite results."
        }
    }
}
