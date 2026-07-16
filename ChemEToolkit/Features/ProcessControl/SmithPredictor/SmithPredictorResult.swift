struct SmithPredictorResult:
    Equatable,
    Sendable {

    let actualDelayedOutput:
        Double
    let modelDelayedOutput:
        Double
    let modelDeadTimeFreeOutput:
        Double

    let modelMismatchCorrection:
        Double
    let smithPredictedOutput:
        Double
    let predictionError:
        Double

    let actualResponseHasStarted:
        Bool
    let modelResponseHasStarted:
        Bool

    let modelAdequacyDescription:
        String

    let modelName: String
    let limitationDescription: String
}
