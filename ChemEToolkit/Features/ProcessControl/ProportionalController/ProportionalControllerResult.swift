struct ProportionalControllerResult: Equatable, Sendable {
    let proportionalContribution: Double
    let unconstrainedOutput: Double
    let constrainedOutput: Double
    let saturationAmount: Double
    let isSaturatedLow: Bool
    let isSaturatedHigh: Bool
    let controllerActionDescription: String
    let modelName: String
    let limitationDescription: String
}
