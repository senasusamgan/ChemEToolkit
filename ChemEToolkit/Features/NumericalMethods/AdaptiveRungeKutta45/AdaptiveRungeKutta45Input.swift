struct AdaptiveRungeKutta45Input: Equatable, Sendable {
    let coefficientA: Double
    let coefficientB: Double
    let initialX: Double
    let finalX: Double
    let initialY: Double
    let initialStep: Double
    let tolerance: Double
    let maximumSteps: Double
}
