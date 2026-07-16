struct FirstOrderPlusDeadTimeProcessResult:
    Equatable,
    Sendable {

    let outputAtEvaluationTime:
        Double
    let finalSteadyStateOutput:
        Double

    let responseHasStarted: Bool
    let activeResponseTime: Double

    let fractionOfFinalChange:
        Double
    let remainingErrorFraction:
        Double

    let deadTimeToTimeConstantRatio:
        Double
    let fivePercentSettlingTime:
        Double
    let twoPercentSettlingTime:
        Double

    let modelName: String
    let limitationDescription: String
}
