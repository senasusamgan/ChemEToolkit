import Foundation

enum BLEVEFireballScreeningError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveMass
    case nonPositiveHeatOfCombustion
    case fractionOutsideRange
    case nonPositiveDistance
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All BLEVE fireball screening inputs must be finite."
        case .nonPositiveMass:
            return "Flammable mass must be greater than zero."
        case .nonPositiveHeatOfCombustion:
            return "Heat of combustion must be greater than zero."
        case .fractionOutsideRange:
            return "Radiant fraction and atmospheric transmissivity must satisfy 0 < value ≤ 1."
        case .nonPositiveDistance:
            return "Receptor distance must be greater than zero."
        case .numericalFailure:
            return "The BLEVE fireball calculation did not produce finite results."
        }
    }
}
