import Foundation

enum EmergencyVentilationDilutionError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveVolume
    case nonPositiveVentilationFlow
    case invalidConcentration
    case negativeElapsedTime
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All ventilation-dilution inputs must be finite."
        case .nonPositiveVolume:
            return "Enclosure volume must be greater than zero."
        case .nonPositiveVentilationFlow:
            return "Ventilation flow rate must be greater than zero."
        case .invalidConcentration:
            return "Initial concentration must be positive and target concentration must satisfy 0 < target < initial."
        case .negativeElapsedTime:
            return "Elapsed time cannot be negative."
        case .numericalFailure:
            return "The ventilation-dilution calculation did not produce finite results."
        }
    }
}
