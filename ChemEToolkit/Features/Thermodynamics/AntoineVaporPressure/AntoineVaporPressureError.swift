import Foundation

enum AntoineVaporPressureError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case singularDenominator
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "Temperature and Antoine coefficients must be finite."
        case .singularDenominator:
            return "Coefficient C plus temperature is too close to zero."
        case .numericalFailure:
            return "The Antoine vapor-pressure calculation did not produce finite positive pressure."
        }
    }
}
