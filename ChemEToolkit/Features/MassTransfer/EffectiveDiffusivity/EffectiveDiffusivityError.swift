import Foundation

enum EffectiveDiffusivityError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveDiffusivity
    case porosityOutOfRange
    case tortuosityBelowUnity
    case constrictivityOutOfRange
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All effective-diffusivity inputs must be finite."

        case .nonPositiveDiffusivity:
            return "Molecular and Knudsen diffusivities must be greater than zero."

        case .porosityOutOfRange:
            return "Porosity must satisfy 0 < ε < 1."

        case .tortuosityBelowUnity:
            return "Tortuosity must be greater than or equal to one."

        case .constrictivityOutOfRange:
            return "Constrictivity must satisfy 0 < δ ≤ 1."

        case .numericalFailure:
            return "The effective-diffusivity calculation did not produce finite physical results."
        }
    }
}
