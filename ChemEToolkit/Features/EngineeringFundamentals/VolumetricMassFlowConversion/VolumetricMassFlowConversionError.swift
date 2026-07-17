import Foundation

enum VolumetricMassFlowConversionError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case negativeVolumetricFlow
    case nonPositiveDensity
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "Volumetric flow rate and density must be finite."
        case .negativeVolumetricFlow:
            return "Volumetric flow rate cannot be negative."
        case .nonPositiveDensity:
            return "Density must be greater than zero."
        case .numericalFailure:
            return "The volumetric-flow conversion did not produce finite results."
        }
    }
}
