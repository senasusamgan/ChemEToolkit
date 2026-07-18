import Foundation

enum CycloneCutDiameterError: Error, Equatable, LocalizedError {
    case nonFiniteInput
case nonPositiveOperatingInput
case invalidDensityDifference
case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput: return "Viscosity, geometry, turns, densities and velocity must be finite."
    case .nonPositiveOperatingInput: return "Viscosity, width, turns and inlet velocity must be greater than zero."
    case .invalidDensityDifference: return "Particle density must exceed gas density."
    case .numericalFailure: return "The cyclone cut-diameter calculation did not produce finite results."
        }
    }
}
