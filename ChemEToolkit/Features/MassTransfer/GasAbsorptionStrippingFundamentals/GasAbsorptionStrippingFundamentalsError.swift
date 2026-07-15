import Foundation

enum GasAbsorptionStrippingFundamentalsError: Error, Equatable, LocalizedError {
    case nonFiniteInput
    case nonPositiveProperty
    case negativeSoluteRatio
    case invalidOperationDirection
    case negativeLiquidOutlet
    case infeasibleEquilibrium
    case pinchOrInsufficientCarrierFlow

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            "All inputs must be finite."
        case .nonPositiveProperty:
            "Solute-free flow rates and the equilibrium-line slope must be greater than zero."
        case .negativeSoluteRatio:
            "Solute ratios cannot be negative."
        case .invalidOperationDirection:
            "Absorption requires Yout < Yin; stripping requires Yout > Yin."
        case .negativeLiquidOutlet:
            "The material balance predicts a negative liquid outlet solute ratio."
        case .infeasibleEquilibrium:
            "The inlet state does not provide a positive equilibrium driving-force range."
        case .pinchOrInsufficientCarrierFlow:
            "The carrier flow reaches or crosses an equilibrium pinch."
        }
    }
}
