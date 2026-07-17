import Foundation

enum ClosedSystemFirstLawError: Error, Equatable, LocalizedError {
    case nonFiniteInput
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "Heat, work and energy changes must be finite."
        case .numericalFailure:
            return "The closed-system first-law calculation did not produce finite results."
        }
    }
}
