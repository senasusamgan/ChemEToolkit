import Foundation

enum FrictionFactorError:
    Error,
    Equatable,
    LocalizedError {

    case invalidReynoldsNumber
    case invalidPipeDiameter
    case invalidAbsoluteRoughness
    case roughnessExceedsDiameter
    case invalidTolerance
    case invalidMaximumIterations
    case transitionalFlowUnsupported
    case iterationDidNotConverge
    case nonFiniteResult

    var errorDescription: String? {
        switch self {
        case .invalidReynoldsNumber:
            return
                "Reynolds number must be greater than zero."

        case .invalidPipeDiameter:
            return
                "Pipe diameter must be greater than zero."

        case .invalidAbsoluteRoughness:
            return
                "Absolute roughness cannot be negative."

        case .roughnessExceedsDiameter:
            return
                "Absolute roughness must be smaller than the pipe diameter."

        case .invalidTolerance:
            return
                "Iteration tolerance must be greater than zero."

        case .invalidMaximumIterations:
            return
                "Maximum iterations must be greater than zero."

        case .transitionalFlowUnsupported:
            return
                "A single reliable friction-factor correlation is not used for transitional flow between Reynolds numbers 2,300 and 4,000."

        case .iterationDidNotConverge:
            return
                "The Colebrook–White calculation did not converge."

        case .nonFiniteResult:
            return
                "The calculated friction factor is not finite."
        }
    }
}
