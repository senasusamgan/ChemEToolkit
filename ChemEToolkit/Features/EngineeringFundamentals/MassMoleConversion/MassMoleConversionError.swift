import Foundation

enum MassMoleConversionError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case negativeMass
    case nonPositiveMolecularWeight
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "Mass and molecular weight must be finite."
        case .negativeMass:
            return "Mass cannot be negative."
        case .nonPositiveMolecularWeight:
            return "Molecular weight must be greater than zero."
        case .numericalFailure:
            return "The mass–mole conversion did not produce finite results."
        }
    }
}
