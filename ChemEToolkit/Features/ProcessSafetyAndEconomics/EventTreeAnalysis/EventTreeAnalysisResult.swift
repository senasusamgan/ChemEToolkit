struct EventTreeAnalysisResult:
    Equatable,
    Sendable {

    let initiatingEventFrequency:
        Double

    let barrier1FailureOutcomeFrequency:
        Double
    let barrier2FailureOutcomeFrequency:
        Double
    let barrier3FailureOutcomeFrequency:
        Double
    let allBarriersSuccessfulFrequency:
        Double

    let totalOutcomeFrequency:
        Double
    let probabilityConservationError:
        Double

    let dominantOutcome: String
    let fullSuccessProbability:
        Double

    let modelName: String
    let limitationDescription: String
}
