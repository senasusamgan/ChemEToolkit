struct PsychrometricAirStreamMixingResult:
    Equatable,
    Sendable {

    let mixedDryAirFlow:
        Double
    let mixedHumidityRatio:
        Double
    let mixedTemperatureC:
        Double
    let mixedEnthalpy:
        Double
    let mixedWaterVaporFlow:
        Double

    let modelName: String
    let limitationDescription:
        String
}
