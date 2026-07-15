import Foundation

enum PackedBedPressureDropError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveFluidProperty
    case nonPositiveGeometry
    case voidFractionOutOfRange
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All packed-bed pressure-drop inputs must be finite."
        case .nonPositiveFluidProperty:
            return "Density, viscosity and superficial velocity must be greater than zero."
        case .nonPositiveGeometry:
            return "Particle diameter and bed length must be greater than zero."
        case .voidFractionOutOfRange:
            return "Bed void fraction must satisfy 0 < ε < 1."
        case .numericalFailure:
            return "The Ergun pressure-drop calculation did not produce finite physical results."
        }
    }
}
