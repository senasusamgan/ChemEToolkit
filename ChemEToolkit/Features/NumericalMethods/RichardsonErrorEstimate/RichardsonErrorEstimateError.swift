import Foundation

enum RichardsonErrorEstimateError: Error, Equatable, LocalizedError {
    case nonFiniteInput
case invalidRefinementRatio
case invalidMethodOrder
case singularExtrapolation
case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput: return "Results, refinement ratio and order must be finite."
    case .invalidRefinementRatio: return "Refinement ratio must be greater than one."
    case .invalidMethodOrder: return "Method order must be greater than zero."
    case .singularExtrapolation: return "The extrapolation denominator is too small."
    case .numericalFailure: return "The Richardson estimate did not produce finite results."
        }
    }
}
