import Foundation

enum MembraneSeparatorBalanceError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveFeedFlow
    case fractionOutsideRange
    case invalidStageCut
    case infeasibleRetentateComposition
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "Feed, composition, stage-cut and rejection inputs must be finite."
        case .nonPositiveFeedFlow:
            return "Feed mass flow must be greater than zero."
        case .fractionOutsideRange:
            return "Feed composition and rejection must lie between zero and one."
        case .invalidStageCut:
            return "Stage-cut fraction must satisfy zero through less than one."
        case .infeasibleRetentateComposition:
            return "The selected feed composition, stage cut and rejection produce an impossible retentate composition."
        case .numericalFailure:
            return "The membrane-separator balance did not produce finite results."
        }
    }
}
