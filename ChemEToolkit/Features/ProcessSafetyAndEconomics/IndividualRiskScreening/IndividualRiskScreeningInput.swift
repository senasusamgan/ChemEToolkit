struct IndividualRiskScreeningInput:
    Equatable,
    Sendable {

    let scenarioFrequencyPerYear:
        Double
    let fatalityProbabilityGivenExposure:
        Double
    let occupancyFraction:
        Double
    let presenceProbability:
        Double
}
