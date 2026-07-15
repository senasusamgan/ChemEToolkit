struct LiquidPhaseDiffusivityInput:
    Equatable,
    Sendable {

    let referenceDiffusivity: Double
    let referenceTemperature: Double
    let referenceViscosity: Double
    let targetTemperature: Double
    let targetViscosity: Double
}
