import Foundation

enum BinaryCompositionBasisConversionError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case massFractionOutsideRange
    case nonPositiveMolecularWeight
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "Mass fraction and molecular weights must be finite."
        case .massFractionOutsideRange:
            return "Component 1 mass fraction must lie between zero and one."
        case .nonPositiveMolecularWeight:
            return "Both molecular weights must be greater than zero."
        case .numericalFailure:
            return "The composition-basis conversion did not produce finite results."
        }
    }
}
