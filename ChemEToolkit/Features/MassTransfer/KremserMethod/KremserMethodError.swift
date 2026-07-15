import Foundation

enum KremserMethodError: Error, Equatable, LocalizedError {
    case nonFiniteInput
    case nonPositiveOperatingFactor
    case nonPositiveInletRatio
    case invalidTargetRatio
    case infeasibleTargetForFactor
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            "All inputs must be finite."
        case .nonPositiveOperatingFactor:
            "The Kremser operating factor must be greater than zero."
        case .nonPositiveInletRatio:
            "The inlet solute ratio must be greater than zero."
        case .invalidTargetRatio:
            "The target outlet ratio must be greater than zero and lower than the inlet ratio."
        case .infeasibleTargetForFactor:
            "For an operating factor below one, the target is at or beyond the infinite-stage limit."
        case .numericalFailure:
            "The stage calculation did not produce a finite physical result."
        }
    }
}
