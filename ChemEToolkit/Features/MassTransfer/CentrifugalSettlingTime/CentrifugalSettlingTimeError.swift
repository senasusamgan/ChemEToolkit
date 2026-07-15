import Foundation

enum CentrifugalSettlingTimeError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveProperty
    case particleNotDenserThanFluid
    case invalidRadiusOrdering
    case stokesRegimeExceeded
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All centrifugation inputs must be finite."

        case .nonPositiveProperty:
            return """
            Particle diameter, particle density, fluid density, viscosity, \
            rotational speed and both radii must be greater than zero.
            """

        case .particleNotDenserThanFluid:
            return "The implemented outward-settling model requires particle density greater than fluid density."

        case .invalidRadiusOrdering:
            return "Final radius must be greater than initial radius."

        case .stokesRegimeExceeded:
            return """
            Outer-radius particle Reynolds number exceeds 0.20. \
            The implemented Stokes centrifugal-settling model is not valid.
            """

        case .numericalFailure:
            return "The centrifugal-settling calculation did not produce finite physical results."
        }
    }
}
