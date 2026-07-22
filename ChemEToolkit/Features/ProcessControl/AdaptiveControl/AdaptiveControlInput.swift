struct AdaptiveControlInput:
    Equatable,
    Sendable {

    let currentControllerGain:
        Double

    let referenceOutput: Double
    let measuredOutput: Double

    let modelOutputSensitivity:
        Double
    let adaptationRate: Double
    let sampleTime: Double

    let minimumControllerGain:
        Double
    let maximumControllerGain:
        Double
}
