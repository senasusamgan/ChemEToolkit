import Foundation

    enum FixedBedAdsorberBreakthroughError:
        Error,
        Equatable,
        LocalizedError {

        case nonFiniteInput
case nonPositiveInput
case invalidBreakthroughFraction
case nonPositiveBreakthroughTime
case numericalFailure

        var errorDescription: String? {
            switch self {
            case .nonFiniteInput:
        return "Bed, concentration, velocity, kinetic and breakthrough inputs must be finite."
    case .nonPositiveInput:
        return "Bed depth, capacity density, inlet concentration, velocity and kinetic constant must be greater than zero."
    case .invalidBreakthroughFraction:
        return "Breakthrough fraction must be greater than zero and less than one-half."
    case .nonPositiveBreakthroughTime:
        return "The selected bed depth is insufficient to produce a positive breakthrough time."
    case .numericalFailure:
        return "The BDST calculation did not produce finite results."
            }
        }
    }
