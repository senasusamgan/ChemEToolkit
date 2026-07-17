import Foundation

enum NozzleDiffuserEnergyBalanceError: Error, Equatable, LocalizedError {
    case nonFiniteInput
    case negativeInletVelocity
    case negativeOutletVelocitySquared
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "Enthalpies, velocity, heat and work inputs must be finite."
        case .negativeInletVelocity:
            return "Inlet velocity cannot be negative."
        case .negativeOutletVelocitySquared:
            return "The selected energy terms produce a negative outlet velocity squared."
        case .numericalFailure:
            return "The nozzle–diffuser calculation did not produce finite results."
        }
    }
}
