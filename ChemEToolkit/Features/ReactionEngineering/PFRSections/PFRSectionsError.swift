import Foundation

enum PFRSectionsError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveConcentrationOrFlow
    case nonPositiveSectionVolumeOrRateConstant
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All PFR-section inputs must be finite."
        case .nonPositiveConcentrationOrFlow:
            return "Inlet concentration and volumetric flow rate must be greater than zero."
        case .nonPositiveSectionVolumeOrRateConstant:
            return "Every section volume and first-order rate constant must be greater than zero."
        case .numericalFailure:
            return "The PFR-section calculation did not produce finite physical results."
        }
    }
}
