struct SocietalRiskFNScreeningResult:
    Equatable,
    Sendable {

    let fatalityCount: Int

    let enteredCumulativeFrequency:
        Double
    let criterionFrequency:
        Double

    let frequencyToCriterionRatio:
        Double
    let log10Frequency:
        Double
    let log10CriterionFrequency:
        Double

    let criterionExceeded: Bool
    let assessmentBand: String
    let assessmentDescription:
        String

    let modelName: String
    let limitationDescription: String
}
