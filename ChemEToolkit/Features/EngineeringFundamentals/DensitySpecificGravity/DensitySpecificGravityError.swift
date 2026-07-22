import Foundation

enum DensitySpecificGravityError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case negativeMass
    case nonPositiveVolume
    case nonPositiveReferenceDensity
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "Mass, volume and reference density must be finite."
        case .negativeMass:
            return "Mass cannot be negative."
        case .nonPositiveVolume:
            return "Volume must be greater than zero."
        case .nonPositiveReferenceDensity:
            return "Reference density must be greater than zero."
        case .numericalFailure:
            return "The density calculation did not produce finite results."
        }
    }
}
