import Foundation

enum EngineeringPrefixConverterError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case invalidPowerOfTen
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "Value and powers of ten must be finite."
        case .invalidPowerOfTen:
            return "Engineering powers must be whole multiples of three from −12 through 12."
        case .numericalFailure:
            return "The engineering-prefix conversion did not produce finite results."
        }
    }
}
