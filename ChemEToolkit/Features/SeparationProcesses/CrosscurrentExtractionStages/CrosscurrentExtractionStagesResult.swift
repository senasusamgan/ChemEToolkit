struct CrosscurrentExtractionStagesResult:
    Equatable,
    Sendable {

    let extractionFactorPerStage:
        Double
    let singleStageFractionRemaining:
        Double

    let continuousStageEstimate:
        Double
    let requiredWholeStages: Int

    let achievedRemovalAtWholeStages:
        Double
    let totalFreshSolvent:
        Double

    let modelName: String
    let limitationDescription: String
}
