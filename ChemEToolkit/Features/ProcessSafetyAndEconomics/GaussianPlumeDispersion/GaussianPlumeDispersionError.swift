import Foundation

enum GaussianPlumeDispersionError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveEmissionRate
    case nonPositiveWindSpeed
    case negativeDistanceOrHeight
    case nonPositiveDispersionCoefficient
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All Gaussian-plume inputs must be finite."
        case .nonPositiveEmissionRate:
            return "Source emission rate must be greater than zero."
        case .nonPositiveWindSpeed:
            return "Wind speed must be greater than zero."
        case .negativeDistanceOrHeight:
            return "Crosswind distance and heights cannot be negative."
        case .nonPositiveDispersionCoefficient:
            return "Horizontal and vertical dispersion coefficients must be greater than zero."
        case .numericalFailure:
            return "The Gaussian-plume calculation did not produce finite results."
        }
    }
}
