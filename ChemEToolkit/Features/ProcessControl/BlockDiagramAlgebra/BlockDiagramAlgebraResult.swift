struct BlockDiagramAlgebraResult:
    Equatable,
    Sendable {

    let seriesGain: Double
    let parallelGain: Double
    let loopGain: Double

    let negativeFeedbackGain:
        Double?
    let positiveFeedbackGain:
        Double?

    let negativeFeedbackSensitivity:
        Double?
    let positiveFeedbackSensitivity:
        Double?

    let singularityDescription:
        String

    let modelName: String
    let limitationDescription: String
}
