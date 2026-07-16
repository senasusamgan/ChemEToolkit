import Foundation

enum ReactorOptimizationError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveFeedCondition
    case nonPositiveRateConstant
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput: return "All reactor-optimization inputs must be finite."
        case .nonPositiveFeedCondition: return "Inlet concentration and volumetric flow rate must be greater than zero."
        case .nonPositiveRateConstant: return "Both consecutive first-order rate constants must be greater than zero."
        case .numericalFailure: return "The reactor-optimization calculation did not produce finite physical results."
        }
    }
}
