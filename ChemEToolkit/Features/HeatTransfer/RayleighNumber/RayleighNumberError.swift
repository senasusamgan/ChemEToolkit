import Foundation

enum RayleighNumberError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case negativeGrashofNumber
    case nonPositivePrandtlNumber

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All entered values must be finite numbers."

        case .negativeGrashofNumber:
            return "Grashof number cannot be negative."

        case .nonPositivePrandtlNumber:
            return "Prandtl number must be greater than zero."
        }
    }
}
