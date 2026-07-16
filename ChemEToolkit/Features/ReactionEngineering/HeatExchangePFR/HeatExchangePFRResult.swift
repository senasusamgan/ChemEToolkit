struct HeatExchangePFRResult: Equatable, Sendable {
    let requiredSpaceTime: Double
    let requiredReactorVolume: Double
    let outletTemperature: Double
    let minimumTemperature: Double
    let maximumTemperature: Double
    let inletRateConstant: Double
    let outletRateConstant: Double
    let outletConcentrationA: Double
    let heatReleasedTemperatureEquivalent: Double
    let heatRemovedTemperatureEquivalent: Double
    let retainedHeatFraction: Double
    let adiabaticReactorVolume: Double
    let heatExchangeToAdiabaticVolumeRatio: Double
    let modelName: String
    let limitationDescription: String
}
