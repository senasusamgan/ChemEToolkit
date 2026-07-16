struct AutocatalyticBatchReactorResult:
    Equatable,
    Sendable {

    let timeToTargetConversion: Double

    let finalConcentrationA: Double
    let finalConcentrationB: Double

    let initialReactionRate: Double
    let finalReactionRate: Double

    let conversionAtMaximumRate:
        Double
    let maximumReactionRate: Double
    let targetOccursAfterRateMaximum:
        Bool

    let modelName: String
    let limitationDescription: String
}
