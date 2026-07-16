struct ProportionalControllerInput: Equatable, Sendable {
    let controllerBias: Double
    let controllerGain: Double
    let currentError: Double
    let minimumOutput: Double
    let maximumOutput: Double
}
