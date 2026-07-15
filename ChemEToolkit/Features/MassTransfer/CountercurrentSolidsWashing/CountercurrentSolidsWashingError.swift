import Foundation

enum CountercurrentSolidsWashingError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveProperty
    case negativeSoluteRatio
    case invalidStageCount
    case noInitialWashingDrivingForce
    case singularStageSystem
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All countercurrent-washing inputs must be finite."

        case .nonPositiveProperty:
            return """
            Insoluble-solid flow, retained-solvent ratio and \
            fresh-wash-solvent flow must be greater than zero.
            """

        case .negativeSoluteRatio:
            return "Feed and fresh-wash solute ratios cannot be negative."

        case .invalidStageCount:
            return "Number of ideal stages must be a whole number from 1 through 100."

        case .noInitialWashingDrivingForce:
            return """
            Fresh wash liquid must have a lower solute ratio than \
            the solution entering with the solids.
            """

        case .singularStageSystem:
            return "The ideal-stage material-balance system could not be solved."

        case .numericalFailure:
            return "The countercurrent-washing calculation did not produce finite physical results."
        }
    }
}
