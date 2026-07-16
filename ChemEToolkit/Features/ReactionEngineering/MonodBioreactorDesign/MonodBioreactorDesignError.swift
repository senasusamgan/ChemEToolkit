import Foundation
enum MonodBioreactorDesignError: Error, Equatable, LocalizedError {
    case nonFiniteInput
    case invalidSubstrateConcentrations
    case nonPositiveGrowthParameter
    case yieldOutOfRange
    case negativeDecayRate
    case nonPositiveFlowRate
    case noPositiveNetGrowth
    case feedCannotSupportBiomass
    case numericalFailure
    var errorDescription: String? {
        switch self {
        case .nonFiniteInput: return "All Monod bioreactor inputs must be finite."
        case .invalidSubstrateConcentrations: return "Feed substrate must be positive and target substrate must satisfy 0 < S < S₀."
        case .nonPositiveGrowthParameter: return "Maximum growth rate and Monod constant must be greater than zero."
        case .yieldOutOfRange: return "Biomass yield must satisfy 0 < Y ≤ 1."
        case .negativeDecayRate: return "Biomass decay rate cannot be negative."
        case .nonPositiveFlowRate: return "Volumetric flow rate must be greater than zero."
        case .noPositiveNetGrowth: return "The selected target substrate does not support positive net biomass growth."
        case .feedCannotSupportBiomass: return "The feed does not support a positive washout dilution rate."
        case .numericalFailure: return "The Monod bioreactor calculation failed."
        }
    }
}
