import Foundation

enum CombustionAirRequirementError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case negativeFuelFlow
    case negativeAtomCount
    case invalidFuelFormula
    case negativeExcessAir
    case invalidOxygenFraction
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "Fuel, atom counts, excess air and oxygen fraction must be finite."
        case .negativeFuelFlow:
            return "Fuel molar flow cannot be negative."
        case .negativeAtomCount:
            return "Fuel atom counts cannot be negative."
        case .invalidFuelFormula:
            return "The entered fuel formula requires a positive stoichiometric oxygen demand."
        case .negativeExcessAir:
            return "Excess-air fraction cannot be negative."
        case .invalidOxygenFraction:
            return "Air oxygen mole fraction must be greater than zero and less than one."
        case .numericalFailure:
            return "The combustion-air calculation did not produce finite results."
        }
    }
}
