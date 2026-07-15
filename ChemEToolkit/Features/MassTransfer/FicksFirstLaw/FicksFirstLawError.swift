import Foundation

enum FicksFirstLawError: Error, Equatable, LocalizedError {
    case nonFiniteInput
    case nonPositiveDiffusivity

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            "All inputs must be finite."
        case .nonPositiveDiffusivity:
            "Diffusivity must be greater than zero."
        }
    }
}
