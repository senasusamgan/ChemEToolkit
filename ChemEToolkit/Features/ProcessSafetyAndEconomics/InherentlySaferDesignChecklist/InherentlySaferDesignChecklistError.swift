import Foundation

enum InherentlySaferDesignChecklistError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case ratingOutsideRange
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All inherently safer design ratings must be finite."
        case .ratingOutsideRange:
            return "Each principle and confidence rating must lie from zero through five."
        case .numericalFailure:
            return "The inherently safer design checklist did not produce finite results."
        }
    }
}
