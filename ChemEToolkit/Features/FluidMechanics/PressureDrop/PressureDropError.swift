import Foundation

enum PressureDropError:
    Error,
    Equatable,
    LocalizedError {

    case invalidPipeLength
    case invalidGravity
    case nonFiniteResult

    var errorDescription: String? {
        switch self {
        case .invalidPipeLength:
            return
                "Pipe length must be greater than zero."

        case .invalidGravity:
            return
                "Gravitational acceleration must be greater than zero."

        case .nonFiniteResult:
            return
                "The calculated pressure drop is not finite."
        }
    }
}
