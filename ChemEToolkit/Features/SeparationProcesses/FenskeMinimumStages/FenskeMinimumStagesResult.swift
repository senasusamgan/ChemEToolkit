struct FenskeMinimumStagesResult:
    Equatable,
    Sendable {

    let minimumTheoreticalStages:
        Double
    let separationFactor: Double
    let distillateLightHeavyRatio:
        Double
    let bottomsLightHeavyRatio:
        Double
    let logarithmicVolatility:
        Double

    let modelName: String
    let limitationDescription: String
}
