import Foundation

enum PackedColumnHTUNTUError: Error, Equatable, LocalizedError {
    case nonFiniteInput
case nonPositiveHTUOrNTU
case invalidSafetyFactor
case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput: return "HTU, NTU and safety factor must be finite."
    case .nonPositiveHTUOrNTU: return "HTU and NTU must be greater than zero."
    case .invalidSafetyFactor: return "Packing safety factor must be at least one."
    case .numericalFailure: return "The packed-column calculation did not produce finite results."
        }
    }
}
