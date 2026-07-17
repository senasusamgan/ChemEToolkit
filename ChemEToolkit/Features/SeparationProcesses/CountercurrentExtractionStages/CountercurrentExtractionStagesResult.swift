struct CountercurrentExtractionStagesResult:
    Equatable,
    Sendable {

    let extractionFactor: Double
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
