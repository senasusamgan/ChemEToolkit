import Foundation

enum MassFractionCalculatorError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case negativeMass
    case zeroTotalMass
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "Component and other masses must be finite."
        case .negativeMass:
            return "Mass values cannot be negative."
        case .zeroTotalMass:
            return "Total mass must be greater than zero."
        case .numericalFailure:
            return "The mass-fraction calculation did not produce finite results."
        }
    }
}
