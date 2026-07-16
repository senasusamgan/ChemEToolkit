struct PIControllerInput: Equatable, Sendable {
    let controllerBias: Double
    let controllerGain: Double
    let currentError: Double
    let accumulatedErrorIntegral: Double
    let integralTime: Double
    let minimumOutput: Double
    let maximumOutput: Double
}
