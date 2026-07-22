import Foundation
enum ConversionFromRTDError: Error, Equatable, LocalizedError {
    case nonFiniteInput, nonPositiveRateConstant, mismatchedArrays, insufficientData
    case nonIncreasingTime, negativeEValue, zeroRTDArea, numericalFailure
    var errorDescription: String? {
        switch self {
        case .nonFiniteInput: return "All RTD conversion inputs must be finite."
        case .nonPositiveRateConstant: return "First-order rate constant must be greater than zero."
        case .mismatchedArrays: return "Time and E(t) arrays must have equal length."
        case .insufficientData: return "At least two RTD points are required."
        case .nonIncreasingTime: return "Time values must be strictly increasing."
        case .negativeEValue: return "E(t) values cannot be negative."
        case .zeroRTDArea: return "Integrated E(t) area must be greater than zero."
        case .numericalFailure: return "The RTD conversion calculation failed."
        }
    }
}
