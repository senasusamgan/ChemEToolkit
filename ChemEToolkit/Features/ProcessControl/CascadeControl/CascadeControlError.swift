import Foundation

enum CascadeControlError: Error, Equatable, LocalizedError {
    case nonFiniteInput
    case singularInnerLoop
    case singularOuterLoop
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput: return "All cascade-control inputs must be finite."
        case .singularInnerLoop: return "The inner-loop denominator 1 + Kc₂G₂ is zero or too close to zero."
        case .singularOuterLoop: return "The outer-loop denominator 1 + Kc₁G₁T₂ is zero or too close to zero."
        case .numericalFailure: return "The cascade-control calculation did not produce finite results."
        }
    }
}
