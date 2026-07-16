struct ZieglerNicholsReactionCurveTuningResult:
    Equatable,
    Sendable {

    let proportionalGain: Double

    let piGain: Double
    let piIntegralTime: Double

    let pidGain: Double
    let pidIntegralTime: Double
    let pidDerivativeTime: Double

    let deadTimeRatio: Double
    let processControllabilityDescription:
        String

    let modelName: String
    let limitationDescription: String
}
