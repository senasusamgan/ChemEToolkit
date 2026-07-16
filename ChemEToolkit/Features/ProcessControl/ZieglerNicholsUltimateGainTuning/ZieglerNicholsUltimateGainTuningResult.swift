struct ZieglerNicholsUltimateGainTuningResult:
    Equatable,
    Sendable {

    let proportionalGain: Double

    let piGain: Double
    let piIntegralTime: Double

    let pidGain: Double
    let pidIntegralTime: Double
    let pidDerivativeTime: Double

    let ultimateFrequency:
        Double
    let tuningAggressivenessDescription:
        String

    let modelName: String
    let limitationDescription: String
}
