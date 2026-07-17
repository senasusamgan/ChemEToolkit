import Foundation

enum ThermalEfficiencyCOPError: Error, Equatable, LocalizedError {
    case nonFiniteInput
    case nonPositiveHighHeat
    case negativeLowHeat
    case invalidHeatOrdering
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "High- and low-temperature heat quantities must be finite."
        case .nonPositiveHighHeat:
            return "High-temperature heat magnitude must be greater than zero."
        case .negativeLowHeat:
            return "Low-temperature heat magnitude cannot be negative."
        case .invalidHeatOrdering:
            return "High-temperature heat must exceed low-temperature heat so that net work is positive."
        case .numericalFailure:
            return "The efficiency and COP calculation did not produce finite results."
        }
    }
}
