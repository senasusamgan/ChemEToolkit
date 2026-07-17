import Foundation

enum MassFlowMolarFlowConversionError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case negativeMassFlow
    case nonPositiveMolecularWeight
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "Mass flow rate and molecular weight must be finite."
        case .negativeMassFlow:
            return "Mass flow rate cannot be negative."
        case .nonPositiveMolecularWeight:
            return "Molecular weight must be greater than zero."
        case .numericalFailure:
            return "The mass-flow conversion did not produce finite results."
        }
    }
}
