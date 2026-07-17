struct ExtractionDistributionSelectivityResult:
    Equatable,
    Sendable {

    let solventToFeedRatio: Double

    let targetExtractionFactor:
        Double
    let impurityExtractionFactor:
        Double

    let targetExtractedFraction:
        Double
    let impurityExtractedFraction:
        Double

    let distributionSelectivity:
        Double
    let extractedFractionSelectivity:
        Double

    let separationDescription:
        String

    let modelName: String
    let limitationDescription: String
}
