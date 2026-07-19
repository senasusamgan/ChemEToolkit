import Foundation
enum QRDecompositionSolverError: Error, Equatable, LocalizedError {
    case invalidDimensions, nonFiniteInput, invalidTolerance, rankDeficient
    var errorDescription: String? {
        switch self {
        case .invalidDimensions: return "QR least squares requires a nonempty m×n matrix with m ≥ n and a matching vector."
        case .nonFiniteInput: return "All inputs must be finite."
        case .invalidTolerance: return "Rank tolerance must be finite and greater than zero."
        case .rankDeficient: return "The matrix is rank deficient at the selected tolerance."
        }
    }
}
