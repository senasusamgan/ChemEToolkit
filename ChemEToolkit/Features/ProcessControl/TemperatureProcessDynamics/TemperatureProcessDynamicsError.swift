import Foundation

enum TemperatureProcessDynamicsError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveThermalProperty
    case invalidTransportParameter
    case nonPhysicalTemperature
    case negativeEvaluationTime
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All temperature-process inputs must be finite."
        case .nonPositiveThermalProperty:
            return "Liquid volume, density and heat capacity must be greater than zero."
        case .invalidTransportParameter:
            return "Volumetric flow rate and heat-transfer conductance cannot be negative, and at least one must be positive."
        case .nonPhysicalTemperature:
            return "All absolute temperatures must be greater than zero kelvin."
        case .negativeEvaluationTime:
            return "Evaluation time cannot be negative."
        case .numericalFailure:
            return "The temperature-process calculation did not produce finite results."
        }
    }
}
