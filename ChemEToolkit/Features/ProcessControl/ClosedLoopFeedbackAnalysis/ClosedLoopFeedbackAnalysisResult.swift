struct ClosedLoopFeedbackAnalysisResult: Equatable, Sendable {
    let loopGain: Double
    let characteristicDenominator: Double
    let closedLoopReferenceGain: Double
    let sensitivityFunction: Double
    let complementarySensitivity: Double
    let outputFromReference: Double
    let outputFromDisturbance: Double
    let totalOutput: Double
    let referenceTrackingError: Double
    let stabilityWarningDescription: String
    let modelName: String
    let limitationDescription: String
}
