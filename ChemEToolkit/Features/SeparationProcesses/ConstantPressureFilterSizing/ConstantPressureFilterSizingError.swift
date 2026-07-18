import Foundation

enum ConstantPressureFilterSizingError: Error, Equatable, LocalizedError {
    case nonFiniteInput
case nonPositiveOperatingInput
case invalidResistance
case negativeSolidsLoading
case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput: return "Volume, area, pressure, viscosity and resistance inputs must be finite."
    case .nonPositiveOperatingInput: return "Filtrate volume, filter area, pressure drop and viscosity must be greater than zero."
    case .invalidResistance: return "Medium and specific-cake resistances cannot be negative."
    case .negativeSolidsLoading: return "Solids per filtrate volume cannot be negative."
    case .numericalFailure: return "The filtration calculation did not produce finite results."
        }
    }
}
