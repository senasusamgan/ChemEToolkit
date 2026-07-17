import Foundation

enum IdealGasMixturePropertiesError:
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
            return "Composition fractions and molecular weights must be finite."
        case .negativeFraction:
            return "Composition fractions cannot be negative."
        case .zeroFractionSum:
            return "At least one composition fraction must be positive."
        case .nonPositiveMolecularWeight:
            return "Molecular weights must be greater than zero."
        case .numericalFailure:
            return "The ideal-gas mixture calculation did not produce finite results."
        }
    }
}
