struct PDControllerResult: Equatable, Sendable {
    let proportionalContribution: Double
    let derivativeContribution: Double
    let unconstrainedOutput: Double
    let constrainedOutput: Double
    let saturationAmount: Double
    let isSaturatedLow: Bool
    let isSaturatedHigh: Bool
    let equivalentDerivativeGain: Double
    let modelName: String
    let limitationDescription: String
}
