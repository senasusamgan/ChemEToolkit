struct IntegratingProcessResponseResult:
    Equatable,
    Sendable {

    let outputAtEvaluationTime:
        Double
    let outputRateOfChange: Double

    let responseHasStarted: Bool
    let activeIntegrationTime:
        Double

    let targetIsReachable: Bool
    let targetReachTime: Double?
    let timeRemainingToTarget:
        Double?

    let responseDirectionDescription:
        String

    let modelName: String
    let limitationDescription: String
}
