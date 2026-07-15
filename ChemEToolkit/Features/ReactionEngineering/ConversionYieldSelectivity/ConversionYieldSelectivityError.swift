import Foundation

enum ConversionYieldSelectivityError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveInitialReactant
    case invalidFinalReactant
    case negativeProductAmount
    case nonPositiveStoichiometricYield
    case noReactantConsumption
    case noAccountedProduct
    case productsExceedReactantConsumption
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All conversion, yield and selectivity inputs must be finite."
        case .nonPositiveInitialReactant:
            return "Initial reactant moles must be greater than zero."
        case .invalidFinalReactant:
            return "Final reactant moles must satisfy 0 ≤ N_A ≤ N_A0."
        case .negativeProductAmount:
            return "Desired and undesired product amounts cannot be negative."
        case .nonPositiveStoichiometricYield:
            return "Product stoichiometric yields must be greater than zero."
        case .noReactantConsumption:
            return "Reactant consumption must be greater than zero."
        case .noAccountedProduct:
            return "At least one desired or undesired product amount must be greater than zero."
        case .productsExceedReactantConsumption:
            return "Product amounts require more reactant than was consumed."
        case .numericalFailure:
            return "The conversion, yield and selectivity calculation did not produce finite physical results."
        }
    }
}
