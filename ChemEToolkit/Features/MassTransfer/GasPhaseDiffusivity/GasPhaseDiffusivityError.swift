import Foundation

enum GasPhaseDiffusivityError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveProperty

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All inputs must be finite."

        case .nonPositiveProperty:
            return """
            Diffusivity, absolute temperatures and \
            absolute pressures must be greater than zero.
            """
        }
    }
}
