import Foundation

enum CrystallizerBalanceError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveFeedFlow
    case fractionOutsideRange
    case invalidPhaseCompositions
    case infeasibleFeedComposition
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "Feed flow and composition fractions must be finite."
        case .nonPositiveFeedFlow:
            return "Feed mass flow must be greater than zero."
        case .fractionOutsideRange:
            return "All composition fractions must lie between zero and one."
        case .invalidPhaseCompositions:
            return "Crystal solute fraction must exceed the mother-liquor solute fraction."
        case .infeasibleFeedComposition:
            return "Feed composition must lie between the entered mother-liquor and crystal compositions."
        case .numericalFailure:
            return "The crystallizer balance did not produce finite results."
        }
    }
}
