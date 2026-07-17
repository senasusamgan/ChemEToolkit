struct SafetyIntegrityLevelTargetInput:
    Equatable,
    Sendable {

    let unmitigatedEventFrequency:
        Double
    let tolerableEventFrequency:
        Double

    let nonSISRiskReductionFactor:
        Double
}
