import Foundation

enum GasAbsorberBalanceError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveGasFlow
    case invalidSoluteFraction
    case invalidAbsorptionTarget
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "Gas flow and solute fractions must be finite."
        case .nonPositiveGasFlow:
            return "Inlet gas molar flow must be greater than zero."
        case .invalidSoluteFraction:
            return "Gas-phase solute fractions must satisfy zero through less than one."
        case .invalidAbsorptionTarget:
            return "Outlet solute fraction cannot exceed the inlet fraction."
        case .numericalFailure:
            return "The gas-absorber balance did not produce finite results."
        }
    }
}
