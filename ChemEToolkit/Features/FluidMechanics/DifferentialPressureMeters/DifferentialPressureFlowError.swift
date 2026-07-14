import Foundation

enum DifferentialPressureFlowError:
    Error,
    Equatable,
    LocalizedError {

    case invalidFluidDensity
    case invalidUpstreamDiameter
    case invalidRestrictionDiameter
    case restrictionMustBeSmaller
    case invalidPressureDifference
    case invalidDischargeCoefficient
    case nonFiniteResult

    var errorDescription: String? {
        switch self {
        case .invalidFluidDensity:
            return
                "Fluid density must be greater than zero."

        case .invalidUpstreamDiameter:
            return
                "Upstream pipe diameter must be greater than zero."

        case .invalidRestrictionDiameter:
            return
                "Restriction diameter must be greater than zero."

        case .restrictionMustBeSmaller:
            return
                "Restriction diameter must be smaller than the upstream pipe diameter."

        case .invalidPressureDifference:
            return
                "Pressure difference cannot be negative."

        case .invalidDischargeCoefficient:
            return
                "Discharge coefficient must be greater than zero and no greater than one."

        case .nonFiniteResult:
            return
                "The calculated flow-meter result is not finite."
        }
    }
}
