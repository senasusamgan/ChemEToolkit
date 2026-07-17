import Foundation

enum StreamSplitterBalanceError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case negativeFeedFlow
    case fractionOutsideRange
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "Feed flow and fractions must be finite."
        case .negativeFeedFlow:
            return "Feed mass flow cannot be negative."
        case .fractionOutsideRange:
            return "Split and component fractions must lie between zero and one."
        case .numericalFailure:
            return "The splitter-balance calculation did not produce finite results."
        }
    }
}
