import Foundation

enum RateConstantCalculationError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveRate
    case nonPositiveConcentration
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All rate-constant inputs must be finite."
        case .nonPositiveRate:
            return "Measured reaction rate must be greater than zero."
        case .nonPositiveConcentration:
            return "Reactant concentrations must be greater than zero."
        case .numericalFailure:
            return "The rate-constant calculation did not produce finite physical results."
        }
    }
}
