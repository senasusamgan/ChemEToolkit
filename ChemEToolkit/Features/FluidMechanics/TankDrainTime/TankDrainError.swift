import Foundation

enum TankDrainError:
    Error,
    Equatable,
    LocalizedError {

    case invalidTankArea
    case invalidOrificeArea
    case orificeAreaExceedsTankArea
    case invalidDischargeCoefficient
    case invalidInitialHeight
    case invalidFinalHeight
    case finalHeightExceedsInitialHeight
    case invalidGravity
    case nonFiniteResult

    var errorDescription: String? {
        switch self {
        case .invalidTankArea:
            return
                "Tank cross-sectional area must be greater than zero."

        case .invalidOrificeArea:
            return
                "Orifice area must be greater than zero."

        case .orificeAreaExceedsTankArea:
            return
                "Orifice area must be smaller than the tank cross-sectional area."

        case .invalidDischargeCoefficient:
            return
                "Discharge coefficient must be greater than zero and no greater than one."

        case .invalidInitialHeight:
            return
                "Initial liquid height cannot be negative."

        case .invalidFinalHeight:
            return
                "Final liquid height cannot be negative."

        case .finalHeightExceedsInitialHeight:
            return
                "Final liquid height cannot exceed the initial liquid height."

        case .invalidGravity:
            return
                "Gravitational acceleration must be greater than zero."

        case .nonFiniteResult:
            return
                "The calculated tank drain result is not finite."
        }
    }
}
