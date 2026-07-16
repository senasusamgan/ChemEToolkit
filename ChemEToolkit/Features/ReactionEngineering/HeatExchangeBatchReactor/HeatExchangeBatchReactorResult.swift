struct HeatExchangeBatchReactorResult: Equatable, Sendable {
    let timeToTargetConversion: Double
    let finalTemperature: Double
    let maximumTemperature: Double
    let finalConcentrationA: Double
    let initialRateConstant: Double
    let finalRateConstant: Double
    let heatReleasedTemperatureEquivalent: Double
    let heatRemovedTemperatureEquivalent: Double
    let retainedHeatFraction: Double
    let modelName: String
    let limitationDescription: String
}
