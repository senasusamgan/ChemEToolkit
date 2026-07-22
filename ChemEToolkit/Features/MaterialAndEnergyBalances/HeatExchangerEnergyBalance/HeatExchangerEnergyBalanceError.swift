import Foundation

enum HeatExchangerEnergyBalanceError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveFlowOrHeatCapacity
    case invalidHotTemperatureChange
    case invalidInletTemperatureOrdering
    case dutyExceedsThermodynamicMaximum
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "Flow rates, heat capacities and temperatures must be finite."
        case .nonPositiveFlowOrHeatCapacity:
            return "Both mass flow rates and heat capacities must be greater than zero."
        case .invalidHotTemperatureChange:
            return "Hot outlet temperature cannot exceed hot inlet temperature."
        case .invalidInletTemperatureOrdering:
            return "Hot inlet temperature must exceed cold inlet temperature."
        case .dutyExceedsThermodynamicMaximum:
            return "The entered hot-side outlet temperature requires more duty than the ideal maximum based on inlet temperatures."
        case .numericalFailure:
            return "The heat-exchanger energy balance did not produce finite results."
        }
    }
}
