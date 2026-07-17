import Foundation

enum TNTEquivalentExplosionScreeningError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveMass
    case nonPositiveHeatOfCombustion
    case invalidExplosionEfficiency
    case nonPositiveDistance
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All TNT-equivalent screening inputs must be finite."
        case .nonPositiveMass:
            return "Flammable mass must be greater than zero."
        case .nonPositiveHeatOfCombustion:
            return "Heat of combustion must be greater than zero."
        case .invalidExplosionEfficiency:
            return "Explosion efficiency must satisfy 0 < η ≤ 1."
        case .nonPositiveDistance:
            return "Receptor distance must be greater than zero."
        case .numericalFailure:
            return "The TNT-equivalent screening calculation did not produce finite results."
        }
    }
}
