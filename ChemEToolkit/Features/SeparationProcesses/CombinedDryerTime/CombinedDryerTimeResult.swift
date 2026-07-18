struct CombinedDryerTimeResult:
    Equatable,
    Sendable {

    let constantRateTime:
        Double
    let fallingRateTime:
        Double
    let totalDryingTime:
        Double

    let totalMoistureRemoved:
        Double
    let constantRateMoistureRemoved:
        Double
    let fallingRateMoistureRemoved:
        Double

    let modelName: String
    let limitationDescription:
        String
}
