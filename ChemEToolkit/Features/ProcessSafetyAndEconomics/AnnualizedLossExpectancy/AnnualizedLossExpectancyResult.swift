struct AnnualizedLossExpectancyResult:
    Equatable,
    Sendable {

    let grossSingleEventLoss: Double
    let insuranceRecovery: Double
    let retainedSingleEventLoss: Double
    let annualizedGrossLoss: Double
    let annualizedRetainedLoss: Double
    let retainedLossFraction: Double
    let dominantLossCategory: String

    let modelName: String
    let limitationDescription: String
}
