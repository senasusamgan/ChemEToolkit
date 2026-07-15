import Foundation

struct FourierNumberResult:
    Equatable,
    Sendable {

    let fourierNumber: Double

    /// sqrt(alpha × time), m.
    let thermalDiffusionLength: Double

    /// sqrt(Fo).
    let normalizedDiffusionLength: Double
}
