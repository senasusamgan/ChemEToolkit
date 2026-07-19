struct RichardsonErrorEstimateResult: Equatable, Sendable {
    let extrapolatedResult: Double
    let estimatedFineGridError: Double
    let estimatedRelativeErrorPercent: Double
    let correctionFactor: Double
    let convergenceDirection: Double
    let modelName: String
    let limitationDescription: String
}
