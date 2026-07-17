struct SocietalRiskFNScreeningInput:
    Equatable,
    Sendable {

    let cumulativeFrequencyPerYear:
        Double
    let fatalityCount: Double

    let referenceFrequencyAtOneFatality:
        Double
    let criterionSlopeExponent:
        Double
}
