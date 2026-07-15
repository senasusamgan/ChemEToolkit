import Foundation

enum CSTRPFRSequenceError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveConcentrationOrFlow
    case nonPositiveVolumeOrRateConstant
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All CSTR–PFR sequence inputs must be finite."
        case .nonPositiveConcentrationOrFlow:
            return "Inlet concentration and volumetric flow rate must be greater than zero."
        case .nonPositiveVolumeOrRateConstant:
            return "Both reactor volumes and first-order rate constants must be greater than zero."
        case .numericalFailure:
            return "The CSTR–PFR sequence calculation did not produce finite physical results."
        }
    }
}
