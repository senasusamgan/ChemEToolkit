import Foundation

enum HeatExchangeBatchReactorError: Error, Equatable, LocalizedError {
    case nonFiniteInput
    case nonPositiveConcentrationOrFactor
    case negativeActivationEnergy
    case nonPositiveTemperature
    case negativeHeatRemovalCoefficient
    case conversionOutOfRange
    case nonPositiveMaximumTime
    case targetNotReached
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All heat-exchange batch inputs must be finite."
        case .nonPositiveConcentrationOrFactor:
            return "Initial concentration and pre-exponential factor must be greater than zero."
        case .negativeActivationEnergy:
            return "Activation energy cannot be negative."
        case .nonPositiveTemperature:
            return "Initial and coolant temperatures must be greater than zero kelvin."
        case .negativeHeatRemovalCoefficient:
            return "Heat-removal coefficient cannot be negative."
        case .conversionOutOfRange:
            return "Target conversion must satisfy 0 < X_A < 1."
        case .nonPositiveMaximumTime:
            return "Maximum integration time must be greater than zero."
        case .targetNotReached:
            return "Target conversion was not reached within the selected maximum integration time."
        case .numericalFailure:
            return "The heat-exchange batch calculation did not produce finite physical results."
        }
    }
}
