struct SafetyIntegrityLevelTargetResult:
    Equatable,
    Sendable {

    let frequencyAfterNonSISProtection:
        Double

    let requiredSIFRiskReductionFactor:
        Double
    let requiredAveragePFD:
        Double

    let targetBand: String
    let targetDescription: String

    let nonSISProtectionIsSufficient:
        Bool

    let modelName: String
    let limitationDescription: String
}
