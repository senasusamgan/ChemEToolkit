import Foundation

enum SingleStageLeachingRecoveryError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveProperty
    case negativeSoluteFlow
    case noOverflowSolution
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All leaching inputs must be finite."

        case .nonPositiveProperty:
            return """
            Insoluble-solid flow, solvent flow and retained-solvent \
            ratio must be greater than zero.
            """

        case .negativeSoluteFlow:
            return "Soluble-solute flow rate cannot be negative."

        case .noOverflowSolution:
            return """
            Added solvent must exceed the solvent retained by the \
            insoluble underflow so that an overflow extract is formed.
            """

        case .numericalFailure:
            return "The single-stage leaching calculation did not produce finite physical results."
        }
    }
}
