struct GasPhaseDiffusivityInput:
    Equatable,
    Sendable {

    let referenceDiffusivity: Double
    let referenceTemperature: Double
    let referencePressure: Double
    let targetTemperature: Double
    let targetPressure: Double
}
