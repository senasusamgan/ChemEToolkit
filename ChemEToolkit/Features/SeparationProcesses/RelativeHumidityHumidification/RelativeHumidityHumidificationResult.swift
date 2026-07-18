struct RelativeHumidityHumidificationResult:
    Equatable,
    Sendable {

    let saturationPressureKPa:
        Double
    let inletHumidityRatio:
        Double
    let outletHumidityRatio:
        Double
    let requiredWaterFlow:
        Double
    let humidityRatioIncrease:
        Double

    let modelName: String
    let limitationDescription:
        String
}
