import Foundation

enum AdiabaticMixingTemperatureError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case negativeMassFlow
    case nonPositiveHeatCapacity
    case zeroTotalCapacityRate
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "Flow rates, heat capacities and temperatures must be finite."
        case .negativeMassFlow:
            return "Stream mass flow rates cannot be negative."
        case .nonPositiveHeatCapacity:
            return "Specific heat capacities must be greater than zero."
        case .zeroTotalCapacityRate:
            return "At least one stream must have positive mass flow."
        case .numericalFailure:
            return "The adiabatic-mixing calculation did not produce finite results."
        }
    }
}
