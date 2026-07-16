struct SecondOrderProcessResponseResult:
    Equatable,
    Sendable {

    let outputAtEvaluationTime:
        Double
    let finalSteadyStateOutput:
        Double

    let normalizedStepResponse:
        Double
    let responseChange: Double

    let dampingRegime:
        String
    let dampedNaturalFrequency:
        Double?

    let percentOvershoot: Double
    let peakTime: Double?
    let approximateTwoPercentSettlingTime:
        Double

    let modelName: String
    let limitationDescription: String
}
