import Foundation

enum SensibleHeatBalanceError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case negativeMassFlow
    case nonPositiveHeatCapacity
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "Flow rate, heat capacity and temperatures must be finite."
        case .negativeMassFlow:
            return "Mass flow rate cannot be negative."
        case .nonPositiveHeatCapacity:
            return "Specific heat capacity must be greater than zero."
        case .numericalFailure:
            return "The sensible-heat calculation did not produce finite results."
        }
    }
}
