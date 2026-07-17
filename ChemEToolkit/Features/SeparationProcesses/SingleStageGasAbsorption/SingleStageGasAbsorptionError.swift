import Foundation

enum SingleStageGasAbsorptionError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveFlow
    case fractionOutsideRange
    case nonPositiveEquilibriumSlope
    case infeasibleOutletComposition
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "Flows, compositions and equilibrium slope must be finite."
        case .nonPositiveFlow:
            return "Gas and liquid molar flow rates must be greater than zero."
        case .fractionOutsideRange:
            return "Gas and liquid solute fractions must lie between zero and one."
        case .nonPositiveEquilibriumSlope:
            return "The equilibrium slope must be greater than zero."
        case .infeasibleOutletComposition:
            return "The selected inputs produce an outlet composition outside the physical range."
        case .numericalFailure:
            return "The single-stage absorption calculation did not produce finite results."
        }
    }
}
