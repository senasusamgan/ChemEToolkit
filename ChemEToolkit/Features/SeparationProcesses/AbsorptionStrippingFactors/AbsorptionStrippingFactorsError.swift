import Foundation

enum AbsorptionStrippingFactorsError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveFlow
    case nonPositiveEquilibriumSlope
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "Flows and equilibrium slope must be finite."
        case .nonPositiveFlow:
            return "Liquid and gas molar flow rates must be greater than zero."
        case .nonPositiveEquilibriumSlope:
            return "The equilibrium slope must be greater than zero."
        case .numericalFailure:
            return "The absorption-factor calculation did not produce finite results."
        }
    }
}
