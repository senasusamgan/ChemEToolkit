import Foundation
enum RTDMomentsError: Error, Equatable, LocalizedError {
    case nonFiniteInput, mismatchedArrays, insufficientData, nonIncreasingTime
    case negativeConcentration, zeroTracerArea, numericalFailure
    var errorDescription: String? {
        switch self {
        case .nonFiniteInput: return "All RTD values must be finite."
        case .mismatchedArrays: return "Time and concentration arrays must have equal length."
        case .insufficientData: return "At least two RTD measurements are required."
        case .nonIncreasingTime: return "Time values must be strictly increasing."
        case .negativeConcentration: return "Tracer concentrations cannot be negative."
        case .zeroTracerArea: return "Integrated tracer area must be greater than zero."
        case .numericalFailure: return "The RTD moment calculation failed."
        }
    }
}
