import Foundation

enum PBRPressureDropEffectsError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveCatalystOrFeed
    case nonPositiveRateConstantOrPressure
    case negativePressureDropParameter
    case pressureCollapse
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All PBR pressure-effect inputs must be finite."
        case .nonPositiveCatalystOrFeed:
            return "Catalyst weight, inlet molar flow and inlet concentration must be greater than zero."
        case .nonPositiveRateConstantOrPressure:
            return "Mass-specific rate constant and inlet pressure must be greater than zero."
        case .negativePressureDropParameter:
            return "Pressure-drop parameter cannot be negative."
        case .pressureCollapse:
            return "The selected catalyst weight gives αW ≥ 1, causing the simplified pressure model to collapse."
        case .numericalFailure:
            return "The PBR pressure-effect calculation did not produce finite physical results."
        }
    }
}
