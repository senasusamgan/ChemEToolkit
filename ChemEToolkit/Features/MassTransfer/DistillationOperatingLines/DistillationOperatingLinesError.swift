import Foundation

enum DistillationOperatingLinesError: Error, Equatable, LocalizedError {
    case nonFiniteInput
    case relativeVolatilityNotGreaterThanOne
    case invalidCompositionOrdering
    case nonPositiveRefluxRatio
    case feedQualityOutOfRange
    case minimumRefluxUnavailable
    case refluxAtOrBelowMinimum
    case invalidOperatingLineIntersection

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput: return "All inputs must be finite."
        case .relativeVolatilityNotGreaterThanOne: return "Relative volatility must be greater than one."
        case .invalidCompositionOrdering: return "Compositions must satisfy 0 < xB < zF < xD < 1 for the selected light component."
        case .nonPositiveRefluxRatio: return "Reflux ratio must be greater than zero."
        case .feedQualityOutOfRange: return "Feed quality q must lie between −1 and 2 for the implemented operating-line model."
        case .minimumRefluxUnavailable: return "A physical q-line/equilibrium pinch could not be identified."
        case .refluxAtOrBelowMinimum: return "Reflux ratio must be greater than the calculated minimum reflux ratio."
        case .invalidOperatingLineIntersection: return "The operating lines do not form a physical feed intersection between xB and xD."
        }
    }
}
