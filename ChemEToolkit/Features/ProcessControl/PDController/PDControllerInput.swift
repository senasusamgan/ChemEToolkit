struct PDControllerInput: Equatable, Sendable {
    let controllerBias: Double
    let controllerGain: Double
    let currentError: Double
    let errorRateOfChange: Double
    let derivativeTime: Double
    let minimumOutput: Double
    let maximumOutput: Double
}
