import Foundation

enum DryingRateTimeError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveProperty
    case negativeMoistureContent
    case invalidMoistureOrdering
    case finalAtOrBelowEquilibrium
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All inputs must be finite."

        case .nonPositiveProperty:
            return """
            Dry-solid mass, drying area and constant drying flux \
            must be greater than zero.
            """

        case .negativeMoistureContent:
            return "Moisture contents cannot be negative."

        case .invalidMoistureOrdering:
            return """
            Initial moisture must exceed final moisture, and critical \
            moisture must exceed equilibrium moisture.
            """

        case .finalAtOrBelowEquilibrium:
            return """
            Final moisture must remain above equilibrium moisture; \
            reaching equilibrium requires infinite time in the linear falling-rate model.
            """

        case .numericalFailure:
            return "The drying-time calculation did not produce finite physical results."
        }
    }
}
