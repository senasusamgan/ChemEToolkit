import Foundation

enum CubicRouthHurwitzStabilityError: Error, Equatable, LocalizedError {
    case nonFiniteInput
    case zeroQuadraticCoefficient
    case singularRouthCase
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput: return "All characteristic-polynomial coefficients must be finite."
        case .zeroQuadraticCoefficient: return "The s² coefficient cannot be zero in this standard cubic Routh table."
        case .singularRouthCase: return "A zero or near-zero first-column Routh element requires the special epsilon or auxiliary-polynomial procedure."
        case .numericalFailure: return "The cubic Routh–Hurwitz calculation did not produce finite results."
        }
    }
}
