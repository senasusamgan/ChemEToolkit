struct AdiabaticMixingTemperatureInput:
    Equatable,
    Sendable {

    let stream1MassFlow: Double
    let stream1HeatCapacity:
        Double
    let stream1Temperature:
        Double

    let stream2MassFlow: Double
    let stream2HeatCapacity:
        Double
    let stream2Temperature:
        Double
}
