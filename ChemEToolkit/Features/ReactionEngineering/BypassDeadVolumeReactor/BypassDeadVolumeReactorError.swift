import Foundation

enum BypassDeadVolumeReactorError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveVolumeOrFlow
    case deadVolumeFractionOutOfRange
    case bypassFractionOutOfRange
    case nonPositiveRateConstant
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All bypass–dead-volume reactor inputs must be finite."
        case .nonPositiveVolumeOrFlow:
            return "Nominal reactor volume and total volumetric flow rate must be greater than zero."
        case .deadVolumeFractionOutOfRange:
            return "Dead-volume fraction must satisfy 0 ≤ f_dead < 1."
        case .bypassFractionOutOfRange:
            return "Bypass fraction must satisfy 0 ≤ b < 1."
        case .nonPositiveRateConstant:
            return "First-order rate constant must be greater than zero."
        case .numericalFailure:
            return "The bypass–dead-volume reactor calculation did not produce finite physical results."
        }
    }
}
