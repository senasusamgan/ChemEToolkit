import Foundation

    enum CombinedDryerTimeError:
        Error,
        Equatable,
        LocalizedError {

        case nonFiniteInput
case nonPositiveMassAreaOrFlux
case invalidMoistureOrdering
case numericalFailure

        var errorDescription: String? {
            switch self {
            case .nonFiniteInput:
        return "Mass, area, moisture contents and drying flux must be finite."
    case .nonPositiveMassAreaOrFlux:
        return "Dry-solid mass, area and drying flux must be greater than zero."
    case .invalidMoistureOrdering:
        return "Moisture contents must satisfy Xi > Xc > Xf > Xe >= 0."
    case .numericalFailure:
        return "The combined drying calculation did not produce finite results."
            }
        }
    }
