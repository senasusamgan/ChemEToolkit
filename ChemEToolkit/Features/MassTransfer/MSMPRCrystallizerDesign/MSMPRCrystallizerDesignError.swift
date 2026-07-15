import Foundation

enum MSMPRCrystallizerDesignError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveProperty
    case negativeEvaluationSize
    case solidsFractionOutsideDiluteModel
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All MSMPR inputs must be finite."

        case .nonPositiveProperty:
            return """
            Residence time, growth rate, nuclei density, crystal density, \
            shape factor and slurry flow must be greater than zero.
            """

        case .negativeEvaluationSize:
            return "Evaluation crystal size cannot be negative."

        case .solidsFractionOutsideDiluteModel:
            return """
            Calculated crystal volume fraction exceeds 0.20. The implemented \
            ideal dilute-slurry MSMPR model is not valid for this input.
            """

        case .numericalFailure:
            return "The MSMPR population-balance calculation did not produce finite physical results."
        }
    }
}
