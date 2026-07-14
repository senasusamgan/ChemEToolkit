import Foundation

enum OpenChannelError:
    Error,
    Equatable,
    LocalizedError {

    case invalidChannelWidth
    case invalidFlowDepth
    case invalidBedSlope
    case invalidManningCoefficient
    case nonFiniteResult

    var errorDescription: String? {
        switch self {
        case .invalidChannelWidth:
            return
                "Channel width must be greater than zero."

        case .invalidFlowDepth:
            return
                "Flow depth must be greater than zero."

        case .invalidBedSlope:
            return
                "Channel bed slope must be greater than zero."

        case .invalidManningCoefficient:
            return
                "Manning roughness coefficient must be greater than zero."

        case .nonFiniteResult:
            return
                "The calculated open-channel flow result is not finite."
        }
    }
}
