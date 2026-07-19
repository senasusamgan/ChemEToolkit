struct AdaptiveRungeKutta45Result: Equatable, Sendable {
    let finalY: Double
    let acceptedSteps: Double
    let rejectedSteps: Double
    let finalStepSize: Double
    let maximumEstimatedError: Double
    let modelName: String
    let limitationDescription: String
}
