import Foundation

enum BypassFractionEstimatorError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveInletConcentration
    case negativeOutletConcentration
    case outletExceedsInlet
    case nonPositiveFlowRate
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "Tracer concentrations and total volumetric flow rate must be finite."
        case .nonPositiveInletConcentration:
            return "Inlet tracer concentration must be greater than zero."
        case .negativeOutletConcentration:
            return "Immediate outlet tracer concentration cannot be negative."
        case .outletExceedsInlet:
            return "Immediate outlet tracer concentration cannot exceed the inlet tracer concentration in this bypass model."
        case .nonPositiveFlowRate:
            return "Total volumetric flow rate must be greater than zero."
        case .numericalFailure:
            return "The bypass-fraction calculation did not produce finite physical results."
        }
    }
}
