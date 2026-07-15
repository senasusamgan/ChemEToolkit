struct AdiabaticBatchReactorResult:
    Equatable,
    Sendable {

    let timeToTargetConversion: Double
    let isothermalTimeAtInitialTemperature:
        Double
    let isothermalToAdiabaticTimeRatio:
        Double

    let initialTemperature: Double
    let finalTemperature: Double
    let temperatureChange: Double

    let initialRateConstant: Double
    let finalRateConstant: Double

    let initialReactionRate: Double
    let finalReactionRate: Double

    let finalConcentrationA: Double

    let modelName: String
    let limitationDescription: String
}
