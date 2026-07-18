import Foundation

enum HydrocycloneSeparationNumberError: Error, Equatable, LocalizedError {
    case nonFiniteInput
case nonPositiveGeometryOrViscosity
case invalidDensityDifference
case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput: return "Particle, liquid and cyclone inputs must be finite."
    case .nonPositiveGeometryOrViscosity: return "Particle diameter, viscosity, tangential velocity and cyclone radius must be greater than zero."
    case .invalidDensityDifference: return "Particle density must exceed liquid density."
    case .numericalFailure: return "The hydrocyclone calculation did not produce finite results."
        }
    }
}
