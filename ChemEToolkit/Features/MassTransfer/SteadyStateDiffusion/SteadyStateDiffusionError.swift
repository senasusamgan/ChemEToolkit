import Foundation

enum SteadyStateDiffusionError: Error, Equatable, LocalizedError {
    case nonFiniteInput
    case nonPositiveGeometryOrDiffusivity
    case negativeConcentration

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            "All inputs must be finite."
        case .nonPositiveGeometryOrDiffusivity:
            "Diffusivity, area, and thickness must be greater than zero."
        case .negativeConcentration:
            "Concentrations cannot be negative."
        }
    }
}
