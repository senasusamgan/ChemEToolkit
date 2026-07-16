struct PIControllerResult: Equatable, Sendable {
    let proportionalContribution: Double
    let integralContribution: Double
    let unconstrainedOutput: Double
    let constrainedOutput: Double
    let saturationAmount: Double
    let isSaturatedLow: Bool
    let isSaturatedHigh: Bool
    let equivalentIntegralGain: Double
    let modelName: String
    let limitationDescription: String
}
