import Foundation

enum ChemicalProcessRiskMatrixError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case invalidLikelihoodRating
    case invalidSeverityRating
    case invalidSafeguardCredit
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All risk-matrix inputs must be finite."
        case .invalidLikelihoodRating:
            return "Likelihood rating must be a whole number from 1 through 5."
        case .invalidSeverityRating:
            return "Severity rating must be a whole number from 1 through 5."
        case .invalidSafeguardCredit:
            return "Safeguard credit must be a whole number from 0 through 4."
        case .numericalFailure:
            return "The risk-matrix calculation did not produce finite results."
        }
    }
}
