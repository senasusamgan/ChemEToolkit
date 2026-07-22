import Foundation

enum MIMODecouplingControlError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case singularGainMatrix
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All 2×2 process-gain matrix elements must be finite."
        case .singularGainMatrix:
            return "The process-gain matrix is singular or too close to singular for static decoupling."
        case .numericalFailure:
            return "The MIMO decoupling calculation did not produce finite results."
        }
    }
}
