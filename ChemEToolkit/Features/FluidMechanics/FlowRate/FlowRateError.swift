import Foundation

enum FlowRateError:
    Error,
    Equatable,
    LocalizedError {

    case invalidDiameter
    case invalidVelocity
    case invalidDensity
    case nonFiniteResult

    var errorDescription: String? {
        switch self {
        case .invalidDiameter:
            return
                "Pipe diameter must be greater than zero."

        case .invalidVelocity:
            return
                "Average flow velocity cannot be negative."

        case .invalidDensity:
            return
                "Fluid density must be greater than zero."

        case .nonFiniteResult:
            return
                "The calculated flow rate is not finite."
        }
    }
}
