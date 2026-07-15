import Foundation

enum MassTransferCoefficientError: Error, Equatable, LocalizedError {
    case nonFiniteInput
    case nonPositiveCoefficientOrArea
    case negativeConcentration

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            "All inputs must be finite."
        case .nonPositiveCoefficientOrArea:
            "Mass-transfer coefficient and area must be greater than zero."
        case .negativeConcentration:
            "Concentrations cannot be negative."
        }
    }
}
