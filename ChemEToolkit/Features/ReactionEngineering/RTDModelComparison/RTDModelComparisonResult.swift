struct RTDModelComparisonResult:
    Equatable,
    Sendable {

    let damkohlerNumber: Double
    let dimensionlessVariance: Double

    let equivalentTanksInSeries:
        Double
    let estimatedPecletNumber:
        Double

    let idealPFRConversion: Double
    let tanksInSeriesConversion:
        Double
    let idealCSTRConversion: Double

    let pfrToTanksConversionDifference:
        Double
    let tanksToCSTRConversionDifference:
        Double

    let modelName: String
    let limitationDescription: String
}
