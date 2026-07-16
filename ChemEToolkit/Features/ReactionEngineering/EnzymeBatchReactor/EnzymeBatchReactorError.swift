import Foundation
enum EnzymeBatchReactorError: Error, Equatable, LocalizedError {
    case nonFiniteInput
    case nonPositiveVolumeOrConcentration
    case invalidKineticParameter
    case conversionOutOfRange
    case numericalFailure
    var errorDescription: String? {
        switch self {
        case .nonFiniteInput: return "All enzyme batch-reactor inputs must be finite."
        case .nonPositiveVolumeOrConcentration: return "Liquid volume and initial substrate concentration must be greater than zero."
        case .invalidKineticParameter: return "Maximum rate must be positive and the Michaelis constant cannot be negative."
        case .conversionOutOfRange: return "Target conversion must satisfy 0 < X < 1."
        case .numericalFailure: return "The enzyme batch-reactor calculation failed."
        }
    }
}
