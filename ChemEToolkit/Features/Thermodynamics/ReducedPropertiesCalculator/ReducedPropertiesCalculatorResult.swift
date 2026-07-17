struct ReducedPropertiesCalculatorResult:
    Equatable,
    Sendable {

    let reducedTemperature: Double
    let reducedPressure: Double
    let temperatureDistanceFromCritical:
        Double
    let pressureDistanceFromCritical:
        Double
    let regionDescription: String

    let modelName: String
    let limitationDescription: String
}
