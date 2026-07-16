struct PIDControllerInput: Equatable, Sendable {
    let controllerBias: Double
    let controllerGain: Double
    let currentError: Double
    let accumulatedErrorIntegral: Double
    let errorRateOfChange: Double
    let integralTime: Double
    let derivativeTime: Double
    let minimumOutput: Double
    let maximumOutput: Double
}
