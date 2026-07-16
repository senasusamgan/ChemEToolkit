struct IMCControllerTuningResult:
    Equatable,
    Sendable {

    let piGain: Double
    let piIntegralTime: Double

    let pidGain: Double
    let pidIntegralTime: Double
    let pidDerivativeTime: Double

    let lambdaToDeadTimeRatio:
        Double
    let robustnessDescription:
        String

    let modelName: String
    let limitationDescription: String
}
