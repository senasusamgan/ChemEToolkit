import Foundation

    enum AdsorbentMassRequirementError:
        Error,
        Equatable,
        LocalizedError {

        case nonFiniteInput
case nonPositiveInput
case invalidUtilization
case numericalFailure

        var errorDescription: String? {
            switch self {
            case .nonFiniteInput:
        return "Rate, time, capacity, utilization and safety factor must be finite."
    case .nonPositiveInput:
        return "Solute rate, cycle time, equilibrium capacity and safety factor must be greater than zero."
    case .invalidUtilization:
        return "Utilization fraction must be greater than zero and no greater than one."
    case .numericalFailure:
        return "The adsorbent-mass calculation did not produce finite results."
            }
        }
    }
