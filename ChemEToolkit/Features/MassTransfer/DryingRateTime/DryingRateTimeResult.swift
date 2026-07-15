struct DryingRateTimeResult:
    Equatable,
    Sendable {

    let constantRateTime: Double
    let fallingRateTime: Double
    let totalDryingTime: Double
    let removedMoistureMass: Double
    let averageDryingFlux: Double
    let finalDryingFlux: Double
    let constantRateMoistureRemoved: Double
    let fallingRateMoistureRemoved: Double
    let periodDescription: String
    let modelName: String
}
