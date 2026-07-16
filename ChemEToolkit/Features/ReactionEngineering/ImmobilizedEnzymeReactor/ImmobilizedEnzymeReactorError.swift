import Foundation
enum ImmobilizedEnzymeReactorError: Error, Equatable, LocalizedError {
    case nonFiniteInput
    case nonPositivePelletProperty
    case nonPositiveKineticParameter
    case nonPositivePelletVolume
    case numericalFailure
    var errorDescription: String? {
        switch self {
        case .nonFiniteInput: return "All immobilized-enzyme inputs must be finite."
        case .nonPositivePelletProperty: return "Pellet radius and effective diffusivity must be greater than zero."
        case .nonPositiveKineticParameter: return "Maximum rate, Michaelis constant and substrate concentration must be greater than zero."
        case .nonPositivePelletVolume: return "Total pellet volume must be greater than zero."
        case .numericalFailure: return "The immobilized-enzyme calculation failed."
        }
    }
}
