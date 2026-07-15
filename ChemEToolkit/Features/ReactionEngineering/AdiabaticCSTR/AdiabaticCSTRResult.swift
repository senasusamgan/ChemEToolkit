struct AdiabaticCSTRResult:
    Equatable,
    Sendable {

    let requiredSpaceTime: Double
    let requiredReactorVolume: Double

    let outletTemperature: Double
    let temperatureChange: Double

    let outletRateConstant: Double
    let outletConcentrationA: Double
    let outletReactionRate: Double

    let isothermalSpaceTimeAtInletTemperature:
        Double
    let isothermalReactorVolume:
        Double
    let isothermalToAdiabaticVolumeRatio:
        Double

    let modelName: String
    let limitationDescription: String
}
