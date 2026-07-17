import Foundation

enum VaporQualityFromEnthalpyError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case invalidSaturationProperties
    case mixtureOutsideSaturationRange
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "Saturated and mixture enthalpies must be finite."
        case .invalidSaturationProperties:
            return "Saturated-vapor enthalpy must exceed saturated-liquid enthalpy."
        case .mixtureOutsideSaturationRange:
            return "Mixture enthalpy must lie between the saturated-liquid and saturated-vapor values."
        case .numericalFailure:
            return "The vapor-quality calculation did not produce finite results."
        }
    }
}
