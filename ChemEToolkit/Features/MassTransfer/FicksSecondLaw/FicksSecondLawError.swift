import Foundation

enum FicksSecondLawError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case equalInitialAndSurfaceConcentrations
    case nonPositiveDiffusivity
    case negativeDepth
    case nonPositiveTime
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All transient-diffusion inputs must be finite."

        case .equalInitialAndSurfaceConcentrations:
            return "Initial and surface concentrations must differ."

        case .nonPositiveDiffusivity:
            return "Diffusivity must be greater than zero."

        case .negativeDepth:
            return "Depth cannot be negative."

        case .nonPositiveTime:
            return "Diffusion time must be greater than zero."

        case .numericalFailure:
            return "The Fick’s-second-law calculation did not produce finite physical results."
        }
    }
}
