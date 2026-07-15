import Foundation

enum SpaceTimeSpaceVelocityError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveVolumeOrFlow
    case holdupFractionOutOfRange
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All space-time and space-velocity inputs must be finite."
        case .nonPositiveVolumeOrFlow:
            return "Reactor volume and inlet volumetric flow rate must be greater than zero."
        case .holdupFractionOutOfRange:
            return "Fluid holdup fraction must satisfy 0 < ε ≤ 1."
        case .numericalFailure:
            return "The space-time calculation did not produce finite physical results."
        }
    }
}
