struct GillilandStageEstimateResult:
    Equatable,
    Sendable {

    let gillilandX: Double
    let gillilandY: Double
    let estimatedTheoreticalStages:
        Double
    let stagesAboveMinimum:
        Double
    let refluxMultipleOfMinimum:
        Double

    let modelName: String
    let limitationDescription: String
}
