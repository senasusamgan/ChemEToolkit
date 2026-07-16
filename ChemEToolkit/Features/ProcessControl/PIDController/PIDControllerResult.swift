struct PIDControllerResult: Equatable, Sendable {
    let proportionalContribution: Double
    let integralContribution: Double
    let derivativeContribution: Double
    let unconstrainedOutput: Double
    let constrainedOutput: Double
    let saturationAmount: Double
    let isSaturatedLow: Bool
    let isSaturatedHigh: Bool
    let proportionalShareFraction: Double?
    let integralShareFraction: Double?
    let derivativeShareFraction: Double?
    let modelName: String
    let limitationDescription: String
}
