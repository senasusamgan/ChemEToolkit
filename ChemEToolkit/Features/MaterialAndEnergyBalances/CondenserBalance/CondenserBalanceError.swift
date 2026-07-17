import Foundation

enum CondenserBalanceError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveFeedFlow
    case fractionOutsideRange
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "Vapor-feed and condensation inputs must be finite."
        case .nonPositiveFeedFlow:
            return "Vapor-feed mass flow must be greater than zero."
        case .fractionOutsideRange:
            return "Condensable and condensation fractions must lie between zero and one."
        case .numericalFailure:
            return "The condenser balance did not produce finite results."
        }
    }
}
