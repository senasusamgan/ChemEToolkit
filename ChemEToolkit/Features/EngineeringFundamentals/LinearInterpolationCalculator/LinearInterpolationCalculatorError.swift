import Foundation

enum LinearInterpolationCalculatorError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case identicalXValues
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All interpolation inputs must be finite."
        case .identicalXValues:
            return "The two known x-values must be different."
        case .numericalFailure:
            return "The interpolation calculation did not produce finite results."
        }
    }
}
