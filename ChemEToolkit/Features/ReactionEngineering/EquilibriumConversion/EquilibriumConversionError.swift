import Foundation

enum EquilibriumConversionError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case negativeInitialConcentration
    case zeroTotalConcentration
    case nonPositiveEquilibriumConstant
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "Initial concentrations and equilibrium constant must be finite."
        case .negativeInitialConcentration:
            return "Initial concentrations cannot be negative."
        case .zeroTotalConcentration:
            return "At least one initial concentration must be greater than zero."
        case .nonPositiveEquilibriumConstant:
            return "Equilibrium constant must be greater than zero."
        case .numericalFailure:
            return "The equilibrium calculation did not produce finite physical results."
        }
    }
}
