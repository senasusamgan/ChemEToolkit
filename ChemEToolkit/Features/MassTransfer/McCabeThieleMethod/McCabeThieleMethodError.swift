import Foundation

enum McCabeThieleMethodError: Error, Equatable, LocalizedError {
    case nonFiniteInput
    case relativeVolatilityNotGreaterThanOne
    case invalidCompositionOrdering
    case nonPositiveRefluxRatio
    case feedQualityOutOfRange
    case minimumRefluxUnavailable
    case refluxAtOrBelowMinimum
    case invalidOperatingLineIntersection
    case nonConvergentStageStepping

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput: return "All inputs must be finite."
        case .relativeVolatilityNotGreaterThanOne: return "Relative volatility must be greater than one."
        case .invalidCompositionOrdering: return "Compositions must satisfy 0 < xB < zF < xD < 1 for the selected light component."
        case .nonPositiveRefluxRatio: return "Reflux ratio must be greater than zero."
        case .feedQualityOutOfRange: return "Feed quality q must lie between −1 and 2."
        case .minimumRefluxUnavailable: return "A physical minimum-reflux pinch could not be identified."
        case .refluxAtOrBelowMinimum: return "Reflux ratio must be greater than the calculated minimum reflux ratio before stage stepping."
        case .invalidOperatingLineIntersection: return "The rectifying, q-line and stripping-line geometry is not physical."
        case .nonConvergentStageStepping: return "McCabe–Thiele stepping did not reach the bottoms specification within 200 equilibrium contacts."
        }
    }
}
