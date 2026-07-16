import Foundation

enum BlockDiagramAlgebraError: Error, Equatable, LocalizedError {
    case nonFiniteInput
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput: return "All block gains must be finite."
        case .numericalFailure: return "The block-diagram algebra calculation did not produce finite results."
        }
    }
}
