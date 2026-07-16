import Foundation

enum EconomicReactorSelectionError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveDesignParameter
    case conversionOutOfRange
    case nonPositiveCapitalCost
    case annualizationFactorOutOfRange
    case negativeOperatingCost
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput: return "All economic reactor-selection inputs must be finite."
        case .nonPositiveDesignParameter: return "Flow rate and first-order rate constant must be greater than zero."
        case .conversionOutOfRange: return "Target conversion must satisfy 0 < X < 1."
        case .nonPositiveCapitalCost: return "Installed cost per unit volume must be greater than zero for both reactors."
        case .annualizationFactorOutOfRange: return "Annualization factor must satisfy 0 < factor ≤ 1."
        case .negativeOperatingCost: return "Annual operating costs cannot be negative."
        case .numericalFailure: return "The economic reactor-selection calculation did not produce finite physical results."
        }
    }
}
