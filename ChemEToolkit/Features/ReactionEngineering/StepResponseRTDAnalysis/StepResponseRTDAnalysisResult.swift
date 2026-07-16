struct StepResponseRTDAnalysisResult:
    Equatable,
    Sendable {

    let normalizedFValues: [Double]
    let intervalEValues: [Double]
    let intervalMidpointTimes:
        [Double]

    let meanResidenceTime: Double
    let medianResidenceTime: Double

    let immediateBypassFraction:
        Double
    let finalResponse: Double

    let responseCompleteness:
        Double

    let modelName: String
    let limitationDescription: String
}
