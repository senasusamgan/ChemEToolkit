import Foundation

enum MinorLossError:
    Error,
    Equatable,
    LocalizedError {

    case invalidDensity
    case invalidVelocity
    case missingLossCoefficients
    case invalidLossCoefficient
    case invalidGravity
    case nonFiniteResult

    var errorDescription: String? {
        switch self {
        case .invalidDensity:
            return
                "Fluid density must be greater than zero."

        case .invalidVelocity:
            return
                "Average flow velocity cannot be negative."

        case .missingLossCoefficients:
            return
                "Enter at least one loss coefficient."

        case .invalidLossCoefficient:
            return
                "Loss coefficients must be finite and cannot be negative."

        case .invalidGravity:
            return
                "Gravitational acceleration must be greater than zero."

        case .nonFiniteResult:
            return
                "The calculated minor loss is not finite."
        }
    }
}
