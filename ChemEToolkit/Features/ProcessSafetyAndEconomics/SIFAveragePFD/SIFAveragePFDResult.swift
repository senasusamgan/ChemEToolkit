struct SIFAveragePFDResult:
    Equatable,
    Sendable {

    let dangerousUndetectedFailureRate:
        Double
    let dangerousDetectedFailureRate:
        Double

    let undetectedPFDContribution:
        Double
    let detectedPFDContribution:
        Double
    let commonCausePFDContribution:
        Double

    let averageProbabilityOfFailureOnDemand:
        Double
    let riskReductionFactor:
        Double

    let lowDemandSILBand: String
    let assessmentDescription:
        String

    let modelName: String
    let limitationDescription: String
}
