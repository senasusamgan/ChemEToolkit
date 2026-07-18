import Foundation

enum AbsorptionMinimumSolventRateError: Error, Equatable, LocalizedError {
    case nonFiniteInput
case nonPositiveGasFlow
case invalidComposition
case invalidEquilibriumSlope
case invalidDesignFactor
case infeasiblePinch
case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput: return "Flows, compositions, slope and design factor must be finite."
    case .nonPositiveGasFlow: return "Gas molar flow must be greater than zero."
    case .invalidComposition: return "Compositions must lie between zero and one, with inlet gas solute above outlet."
    case .invalidEquilibriumSlope: return "Equilibrium slope must be greater than zero."
    case .invalidDesignFactor: return "Design factor must be at least one."
    case .infeasiblePinch: return "The equilibrium pinch composition must exceed the entering-solvent composition."
    case .numericalFailure: return "The minimum-solvent calculation did not produce finite results."
        }
    }
}
