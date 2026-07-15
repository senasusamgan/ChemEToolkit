import Foundation

enum PackedColumnHTUNTUDesignError: Error, Equatable, LocalizedError {
    case nonFiniteInput
    case nonPositiveProperty
    case negativeSoluteRatio
    case invalidAbsorptionDirection
    case infeasibleEquilibrium
    case pinchOrCrossedOperatingLine
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            "All inputs must be finite."
        case .nonPositiveProperty:
            "Flow rates, equilibrium slope and overall gas HTU must be greater than zero."
        case .negativeSoluteRatio:
            "Solute ratios cannot be negative."
        case .invalidAbsorptionDirection:
            "Gas inlet ratio must be greater than gas outlet ratio for absorption."
        case .infeasibleEquilibrium:
            "The inlet state does not permit a positive minimum-solvent calculation."
        case .pinchOrCrossedOperatingLine:
            "The operating line reaches or crosses equilibrium."
        case .numericalFailure:
            "The HTU–NTU calculation did not produce a finite result."
        }
    }
}
