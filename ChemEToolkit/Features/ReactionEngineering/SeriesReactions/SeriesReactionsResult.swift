struct SeriesReactionsResult:
    Equatable,
    Sendable {

    let concentrationA: Double
    let intermediateConcentrationB:
        Double
    let finalProductConcentrationC:
        Double

    let conversionOfA: Double
    let intermediateYieldOnFeed:
        Double
    let intermediateFractionOfProducts:
        Double

    let timeOfMaximumIntermediate:
        Double
    let maximumIntermediateConcentration:
        Double

    let modelName: String
    let limitationDescription: String
}
