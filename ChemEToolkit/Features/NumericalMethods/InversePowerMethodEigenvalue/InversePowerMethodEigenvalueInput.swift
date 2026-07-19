struct InversePowerMethodEigenvalueInput: Equatable, Sendable {
    let a11: Double
    let a12: Double
    let a21: Double
    let a22: Double
    let shift: Double
    let initialX: Double
    let initialY: Double
    let tolerance: Double
    let maximumIterations: Double
}
