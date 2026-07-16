struct CascadeControlResult: Equatable, Sendable {
    let innerLoopGain: Double
    let innerClosedLoopGain: Double
    let innerSensitivity: Double

    let effectiveOuterProcessGain:
        Double
    let outerLoopGain: Double
    let outerClosedLoopGain: Double
    let outerSensitivity: Double

    let outputFromReference: Double
    let outputFromSecondaryDisturbance:
        Double
    let totalPrimaryOutput: Double

    let modelName: String
    let limitationDescription: String
}
