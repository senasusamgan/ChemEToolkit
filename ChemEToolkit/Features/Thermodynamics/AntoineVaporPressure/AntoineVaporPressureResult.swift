struct AntoineVaporPressureResult:
    Equatable,
    Sendable {

    let denominator: Double
    let log10Pressure: Double
    let vaporPressure: Double
    let naturalLogPressure:
        Double

    let modelName: String
    let limitationDescription: String
}
