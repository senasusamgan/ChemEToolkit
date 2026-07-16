struct HeatExchangeCSTRResult: Equatable, Sendable {
    let outletTemperature: Double
    let requiredSpaceTime: Double
    let requiredReactorVolume: Double
    let outletRateConstant: Double
    let outletConcentrationA: Double
    let outletReactionRate: Double
    let adiabaticOutletTemperature: Double
    let heatRemovedTemperatureEquivalent: Double
    let retainedHeatFraction: Double
    let adiabaticReactorVolume: Double
    let heatExchangeToAdiabaticVolumeRatio: Double
    let modelName: String
    let limitationDescription: String
}
