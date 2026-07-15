import Foundation

enum UltrafiltrationConcentrationPolarizationError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveProperty
    case gelConcentrationNotAboveBulk
    case sievingCoefficientOutOfRange
    case recoveryOutsideLowRecoveryModel
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All ultrafiltration inputs must be finite."

        case .nonPositiveProperty:
            return """
            Feed flow, membrane area, mass-transfer coefficient and \
            bulk concentration must be greater than zero.
            """

        case .gelConcentrationNotAboveBulk:
            return "Gel concentration must be greater than the bulk solute concentration."

        case .sievingCoefficientOutOfRange:
            return "Observed sieving coefficient must satisfy 0 ≤ S ≤ 1."

        case .recoveryOutsideLowRecoveryModel:
            return """
            Calculated volumetric recovery exceeds 0.30. Reduce membrane \
            area or increase feed flow for the implemented low-recovery model.
            """

        case .numericalFailure:
            return "The ultrafiltration calculation did not produce finite physical results."
        }
    }
}
