import Foundation

enum IdealGasMembraneStageCutError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveFeedFlow
    case invalidComposition
    case invalidStageCut
    case invalidSelectivity
    case infeasibleRetentateComposition
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "Flow, composition, stage cut and selectivity must be finite."
        case .nonPositiveFeedFlow:
            return "Feed molar flow must be greater than zero."
        case .invalidComposition:
            return "Feed composition must be greater than zero and less than one."
        case .invalidStageCut:
            return "Stage cut must be greater than zero and less than one."
        case .invalidSelectivity:
            return "Ideal selectivity must be greater than one."
        case .infeasibleRetentateComposition:
            return "The selected stage cut produces an infeasible retentate composition."
        case .numericalFailure:
            return "The membrane stage-cut calculation did not produce finite results."
        }
    }
}
