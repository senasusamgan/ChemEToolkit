import Foundation

enum ManometerError:
    Error,
    Equatable,
    LocalizedError {

    case invalidProcessFluidDensity
    case invalidManometerFluidDensity
    case manometerFluidMustBeDenser
    case invalidHeightDifference
    case invalidGravity
    case nonFiniteResult

    var errorDescription: String? {
        switch self {
        case .invalidProcessFluidDensity:
            return
                "Process fluid density must be greater than zero."

        case .invalidManometerFluidDensity:
            return
                "Manometer fluid density must be greater than zero."

        case .manometerFluidMustBeDenser:
            return
                "The manometer fluid must be denser than the process fluid for this calculation."

        case .invalidHeightDifference:
            return
                "Height difference cannot be negative."

        case .invalidGravity:
            return
                "Gravitational acceleration must be greater than zero."

        case .nonFiniteResult:
            return
                "The calculated pressure difference is not finite."
        }
    }
}
