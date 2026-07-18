import Foundation

    enum DryerThermalDutyError:
        Error,
        Equatable,
        LocalizedError {

        case nonFiniteInput
case nonPositiveDrySolidFlow
case invalidMoistureOrdering
case invalidHeatInput
case invalidEfficiency
case numericalFailure

        var errorDescription: String? {
            switch self {
            case .nonFiniteInput:
        return "Flow, moisture, heat and efficiency inputs must be finite."
    case .nonPositiveDrySolidFlow:
        return "Dry-solid mass flow must be greater than zero."
    case .invalidMoistureOrdering:
        return "Inlet moisture must exceed nonnegative outlet moisture."
    case .invalidHeatInput:
        return "Latent heat must be greater than zero and sensible duty cannot be negative."
    case .invalidEfficiency:
        return "Thermal efficiency must be greater than zero and no greater than one."
    case .numericalFailure:
        return "The dryer-duty calculation did not produce finite results."
            }
        }
    }
