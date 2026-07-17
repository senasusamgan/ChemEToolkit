import Foundation

enum EquipmentCostScalingError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveCostOrCapacity
    case scalingExponentOutOfRange
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All equipment cost-scaling inputs must be finite."
        case .nonPositiveCostOrCapacity:
            return "Reference cost and both equipment capacities must be greater than zero."
        case .scalingExponentOutOfRange:
            return "Scaling exponent must satisfy 0 < n ≤ 2."
        case .numericalFailure:
            return "The equipment cost-scaling calculation did not produce finite results."
        }
    }
}
