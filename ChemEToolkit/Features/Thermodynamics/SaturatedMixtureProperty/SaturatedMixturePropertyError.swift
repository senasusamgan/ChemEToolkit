import Foundation

enum SaturatedMixturePropertyError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case fractionOutsideRange
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "Saturated properties and vapor quality must be finite."
        case .fractionOutsideRange:
            return "Vapor quality must lie between zero and one."
        case .numericalFailure:
            return "The saturated-mixture property calculation did not produce finite results."
        }
    }
}
