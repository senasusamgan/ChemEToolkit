struct KremserAbsorptionStagesResult:
    Equatable,
    Sendable {

    let fractionRemaining: Double
    let continuousStageEstimate:
        Double
    let requiredWholeStages: Int
    let achievedRemovalAtWholeStages:
        Double
    let stageMargin: Double

    let modelName: String
    let limitationDescription: String
}
