struct AntoineVaporPressureInput:
    Equatable,
    Sendable {

    let temperatureCelsius: Double
    let coefficientA: Double
    let coefficientB: Double
    let coefficientC: Double
}
