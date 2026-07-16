import Foundation

enum NonIsothermalCSTRSteadyStatesError: Error, Equatable, LocalizedError {
    case nonFiniteInput
    case nonPositiveConcentrationOrSpaceTime
    case nonPositivePreExponentialFactor
    case negativeActivationEnergy
    case nonPositiveTemperature
    case nonPositiveAdiabaticRise
    case negativeHeatRemovalNumber
    case noSteadyStateFound
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All non-isothermal CSTR inputs must be finite."
        case .nonPositiveConcentrationOrSpaceTime:
            return "Inlet concentration and space time must be greater than zero."
        case .nonPositivePreExponentialFactor:
            return "Pre-exponential factor must be greater than zero."
        case .negativeActivationEnergy:
            return "Activation energy cannot be negative."
        case .nonPositiveTemperature:
            return "Inlet, coolant and search-range temperatures must remain greater than zero kelvin."
        case .nonPositiveAdiabaticRise:
            return "Adiabatic temperature rise must be greater than zero for multiplicity analysis."
        case .negativeHeatRemovalNumber:
            return "Heat-removal number cannot be negative."
        case .noSteadyStateFound:
            return "No steady-state intersection was detected in the physical conversion range."
        case .numericalFailure:
            return "The non-isothermal CSTR calculation did not produce finite physical results."
        }
    }
}
