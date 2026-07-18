import Foundation

enum MurphreeTrayEfficiencyError: Error, Equatable, LocalizedError {
    case nonFiniteInput
case nonPositiveIdealStages
case invalidEfficiency
case nonPositiveTraySpacing
case invalidSafetyFactor
case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput: return "Stage count, efficiency, spacing and safety factor must be finite."
    case .nonPositiveIdealStages: return "Ideal stage count must be greater than zero."
    case .invalidEfficiency: return "Murphree efficiency must be greater than zero and no greater than one."
    case .nonPositiveTraySpacing: return "Tray spacing must be greater than zero."
    case .invalidSafetyFactor: return "Height safety factor must be at least one."
    case .numericalFailure: return "The tray-efficiency calculation did not produce finite results."
        }
    }
}
