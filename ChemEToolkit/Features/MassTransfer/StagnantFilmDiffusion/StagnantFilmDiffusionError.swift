import Foundation

enum StagnantFilmDiffusionError: Error, Equatable, LocalizedError {
    case nonFiniteInput
    case nonPositiveProperty
    case invalidMoleFraction
    case singularInertFraction

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            "All inputs must be finite."
        case .nonPositiveProperty:
            "Diffusivity, pressure, temperature, and thickness must be greater than zero."
        case .invalidMoleFraction:
            "Mole fractions must lie between zero and one."
        case .singularInertFraction:
            "The stagnant-component fraction must remain greater than zero at both boundaries."
        }
    }
}
