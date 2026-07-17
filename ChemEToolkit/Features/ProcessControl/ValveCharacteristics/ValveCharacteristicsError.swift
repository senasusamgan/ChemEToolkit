import Foundation

enum ValveCharacteristicsError: Error, Equatable, LocalizedError {
    case nonFiniteInput
    case openingOutsideRange
    case nonPositiveRatedKv
    case invalidRangeability
    case nonPositivePressureDrop
    case nonPositiveDensity
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All valve-characteristic inputs must be finite."
        case .openingOutsideRange:
            return "Valve opening must be between zero and one hundred percent."
        case .nonPositiveRatedKv:
            return "Rated valve Kv must be greater than zero."
        case .invalidRangeability:
            return "Equal-percentage rangeability must be greater than one."
        case .nonPositivePressureDrop:
            return "Valve pressure drop must be greater than zero."
        case .nonPositiveDensity:
            return "Liquid density must be greater than zero."
        case .numericalFailure:
            return "The valve-characteristic calculation did not produce finite results."
        }
    }
}
