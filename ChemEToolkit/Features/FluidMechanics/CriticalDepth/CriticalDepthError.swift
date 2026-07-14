import Foundation

enum CriticalDepthError:
    Error,
    Equatable,
    LocalizedError {

    case invalidFlowRate
    case invalidChannelWidth
    case invalidCurrentDepth
    case invalidGravity
    case nonFiniteResult

    var errorDescription: String? {
        switch self {
        case .invalidFlowRate:
            return
                "Volumetric flow rate must be greater than zero."

        case .invalidChannelWidth:
            return
                "Channel width must be greater than zero."

        case .invalidCurrentDepth:
            return
                "Current flow depth must be greater than zero."

        case .invalidGravity:
            return
                "Gravitational acceleration must be greater than zero."

        case .nonFiniteResult:
            return
                "The calculated critical-depth result is not finite."
        }
    }
}
