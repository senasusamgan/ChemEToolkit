import Foundation

enum DiffusionThroughMembraneError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveTransportProperty
    case negativeConcentration
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All membrane-diffusion inputs must be finite."

        case .nonPositiveTransportProperty:
            return """
            Membrane diffusivity, partition coefficient, membrane thickness \
            and membrane area must be greater than zero.
            """

        case .negativeConcentration:
            return "Bulk concentrations cannot be negative."

        case .numericalFailure:
            return "The membrane-diffusion calculation did not produce finite physical results."
        }
    }
}
