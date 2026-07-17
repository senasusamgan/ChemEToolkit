struct ExtractionSolventRequirementResult:
    Equatable,
    Sendable {

    let requiredSolventFlow: Double
    let solventToFeedRatio: Double
    let extractionFactor: Double

    let raffinateSoluteFraction:
        Double
    let extractSoluteFraction:
        Double

    let soluteExtractedFlow: Double
    let soluteRemainingFlow: Double

    let modelName: String
    let limitationDescription: String
}
