struct AdaptiveControlResult:
    Equatable,
    Sendable {

    let trackingError: Double
    let adaptationSignal: Double

    let requestedGainUpdate: Double
    let appliedGainUpdate: Double

    let unconstrainedUpdatedGain:
        Double
    let updatedControllerGain:
        Double

    let currentTrackingCost:
        Double
    let predictedTrackingError:
        Double
    let predictedTrackingCost:
        Double

    let predictedImprovementFraction:
        Double
    let gainLimitIsActive: Bool
    let adaptationDescription:
        String

    let modelName: String
    let limitationDescription: String
}
