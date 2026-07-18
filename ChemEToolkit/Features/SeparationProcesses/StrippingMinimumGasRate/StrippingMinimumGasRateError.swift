import Foundation

enum StrippingMinimumGasRateError: Error, Equatable, LocalizedError {
    case nonFiniteInput
case nonPositiveLiquidFlow
case invalidComposition
case invalidEquilibriumSlope
case invalidDesignFactor
case infeasiblePinch
case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput: return "Flows, compositions, slope and design factor must be finite."
    case .nonPositiveLiquidFlow: return "Liquid molar flow must be greater than zero."
    case .invalidComposition: return "Liquid compositions must lie between zero and one, with inlet above outlet."
    case .invalidEquilibriumSlope: return "Equilibrium slope must be greater than zero."
    case .invalidDesignFactor: return "Design factor must be at least one."
    case .infeasiblePinch: return "The pinch gas composition must exceed the entering-gas composition."
    case .numericalFailure: return "The minimum-gas calculation did not produce finite results."
        }
    }
}
