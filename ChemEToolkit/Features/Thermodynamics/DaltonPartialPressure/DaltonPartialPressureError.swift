import Foundation

enum DaltonPartialPressureError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositivePressure
    case negativeFraction
    case zeroFractionSum
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "Pressure and composition fractions must be finite."
        case .nonPositivePressure:
            return "Total absolute pressure must be greater than zero."
        case .negativeFraction:
            return "Composition fractions cannot be negative."
        case .zeroFractionSum:
            return "At least one composition fraction must be positive."
        case .numericalFailure:
            return "The partial-pressure calculation did not produce finite results."
        }
    }
}
