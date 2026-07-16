struct FirstOrderProcessResponseResult:
    Equatable,
    Sendable {

    let outputAtEvaluationTime:
        Double
    let finalSteadyStateOutput:
        Double

    let responseChange: Double
    let fractionOfFinalChange:
        Double
    let remainingErrorFraction:
        Double

    let initialResponseSlope: Double
    let halfResponseTime: Double
    let fivePercentSettlingTime:
        Double
    let twoPercentSettlingTime:
        Double

    let responseDirectionDescription:
        String

    let modelName: String
    let limitationDescription: String
}
