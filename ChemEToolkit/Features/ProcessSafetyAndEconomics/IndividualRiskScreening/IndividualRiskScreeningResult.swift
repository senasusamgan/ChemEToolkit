struct IndividualRiskScreeningResult:
    Equatable,
    Sendable {

    let annualIndividualRisk:
        Double
    let annualIndividualRiskPerMillion:
        Double

    let combinedExposureProbability:
        Double
    let returnPeriodYears:
        Double

    let screeningBand: String
    let assessmentDescription:
        String

    let modelName: String
    let limitationDescription: String
}
