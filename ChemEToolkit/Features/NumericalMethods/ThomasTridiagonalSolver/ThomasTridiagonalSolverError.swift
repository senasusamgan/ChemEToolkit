import Foundation
enum ThomasTridiagonalSolverError: Error, Equatable, LocalizedError {
    case invalidDimensions, nonFiniteInput, invalidTolerance, zeroPivot
    var errorDescription: String? {
        switch self {
        case .invalidDimensions: return "For n unknowns, the main and constant arrays need n values and off-diagonals need n−1 values."
        case .nonFiniteInput: return "All inputs must be finite."
        case .invalidTolerance: return "Pivot tolerance must be finite and greater than zero."
        case .zeroPivot: return "A zero or near-zero pivot prevents the Thomas algorithm from continuing."
        }
    }
}
