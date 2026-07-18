struct PsychrometricAirStreamMixingInput:
    Equatable,
    Sendable {

    let dryAirFlow1: Double
    let temperature1C: Double
    let humidityRatio1: Double

    let dryAirFlow2: Double
    let temperature2C: Double
    let humidityRatio2: Double
}
