import Foundation

enum ChemicalFormulaMolecularWeightError:
    Error,
    Equatable,
    LocalizedError {

    case emptyFormula
    case invalidFormula
    case unknownElement
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .emptyFormula:
            return "Chemical formula cannot be empty."
        case .invalidFormula:
            return "Use a simple formula containing element symbols and positive integer subscripts."
        case .unknownElement:
            return "The formula contains an element that is not available in the built-in atomic-weight table."
        case .numericalFailure:
            return "The molecular-weight calculation did not produce a finite result."
        }
    }
}
