import Foundation

enum FixedBedAdsorptionBDSTError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveProperty
    case invalidBreakthroughRatio
    case bedDepthBelowMinimum
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All BDST inputs must be finite."

        case .nonPositiveProperty:
            return """
            Bed depth, column area, superficial velocity, influent \
            concentration, bed capacity and kinetic coefficient \
            must be greater than zero.
            """

        case .invalidBreakthroughRatio:
            return """
            Breakthrough concentration must satisfy \
            0 < Cb/C0 < 0.5 for the implemented BDST breakthrough form.
            """

        case .bedDepthBelowMinimum:
            return """
            Selected bed depth is below the zero-service-time \
            minimum depth predicted by the BDST model.
            """

        case .numericalFailure:
            return "The BDST calculation did not produce finite physical results."
        }
    }
}
