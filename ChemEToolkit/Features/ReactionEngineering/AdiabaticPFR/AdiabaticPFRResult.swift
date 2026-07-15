struct AdiabaticPFRResult:
    Equatable,
    Sendable {

    let requiredSpaceTime: Double
    let requiredReactorVolume: Double

    let isothermalSpaceTimeAtInletTemperature:
        Double
    let isothermalReactorVolume:
        Double
    let isothermalToAdiabaticVolumeRatio:
        Double

    let outletTemperature: Double
    let temperatureChange: Double

    let inletRateConstant: Double
    let outletRateConstant: Double

    let outletConcentrationA: Double
    let outletReactionRate: Double

    let modelName: String
    let limitationDescription: String
}
