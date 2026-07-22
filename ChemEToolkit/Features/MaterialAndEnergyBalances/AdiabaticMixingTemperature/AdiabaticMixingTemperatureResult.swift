struct AdiabaticMixingTemperatureResult:
    Equatable,
    Sendable {

    let mixedTemperature: Double
    let totalMassFlow: Double
    let stream1HeatCapacityRate:
        Double
    let stream2HeatCapacityRate:
        Double
    let totalHeatCapacityRate:
        Double

    let modelName: String
    let limitationDescription: String
}
