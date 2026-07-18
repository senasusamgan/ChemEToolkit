import Foundation

    enum BETMonolayerCapacityError:
        Error,
        Equatable,
        LocalizedError {

        case nonFiniteInput
case invalidRelativePressure
case nonPositiveParameter
case numericalFailure

        var errorDescription: String? {
            switch self {
            case .nonFiniteInput:
        return "Relative pressure, monolayer capacity and BET constant must be finite."
    case .invalidRelativePressure:
        return "Relative pressure must be greater than zero and less than one."
    case .nonPositiveParameter:
        return "Monolayer capacity and BET constant must be greater than zero."
    case .numericalFailure:
        return "The BET calculation did not produce finite results."
            }
        }
    }
