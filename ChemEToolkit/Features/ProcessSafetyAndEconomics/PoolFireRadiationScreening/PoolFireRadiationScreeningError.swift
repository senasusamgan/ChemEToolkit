import Foundation

enum PoolFireRadiationScreeningError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveMassRate
    case nonPositiveHeatOfCombustion
    case fractionOutsideRange
    case nonPositiveDistance
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All pool-fire screening inputs must be finite."
        case .nonPositiveMassRate:
            return "Burning mass rate must be greater than zero."
        case .nonPositiveHeatOfCombustion:
            return "Heat of combustion must be greater than zero."
        case .fractionOutsideRange:
            return "Radiant fraction and atmospheric transmissivity must satisfy 0 < value ≤ 1."
        case .nonPositiveDistance:
            return "Receptor distance must be greater than zero."
        case .numericalFailure:
            return "The pool-fire radiation calculation did not produce finite results."
        }
    }
}
