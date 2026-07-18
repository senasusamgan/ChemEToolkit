import Foundation

enum CoolingCrystallizerYieldError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveSolventMass
    case invalidSolubility
    case invalidPurity
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "Solvent mass, solubilities and purity must be finite."
        case .nonPositiveSolventMass:
            return "Solvent mass must be greater than zero."
        case .invalidSolubility:
            return "Hot solubility must exceed nonnegative cold solubility."
        case .invalidPurity:
            return "Crystal purity must be greater than zero and no greater than one."
        case .numericalFailure:
            return "The cooling-crystallizer calculation did not produce finite results."
        }
    }
}
