struct ProofTestIntervalCalculatorResult:
    Equatable,
    Sendable {

    let dangerousUndetectedFailureRate:
        Double
    let dangerousDetectedFailureRate:
        Double

    let fixedPFDContribution:
        Double
    let remainingPFDAllowance:
        Double

    let maximumProofTestIntervalHours:
        Double
    let maximumProofTestIntervalDays:
        Double
    let maximumProofTestIntervalYears:
        Double

    let achievedAveragePFDAtInterval:
        Double
    let targetRiskReductionFactor:
        Double
    let targetLowDemandBand:
        String

    let modelName: String
    let limitationDescription: String
}
