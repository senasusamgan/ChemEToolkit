import Foundation

enum EquimolarCounterDiffusionError: Error, Equatable, LocalizedError {
    case nonFiniteInput
    case nonPositiveProperty
    case invalidMoleFraction

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            "All inputs must be finite."
        case .nonPositiveProperty:
            "Diffusivity, pressure, temperature, and thickness must be greater than zero."
        case .invalidMoleFraction:
            "Mole fractions must lie between zero and one."
        }
    }
}
