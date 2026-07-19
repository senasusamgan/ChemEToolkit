struct GaussNewtonNonlinearRegressionInput: Equatable, Sendable {
    let x1: Double
    let y1: Double
    let x2: Double
    let y2: Double
    let x3: Double
    let y3: Double
    let initialA: Double
    let initialB: Double
    let tolerance: Double
    let maximumIterations: Double
}
