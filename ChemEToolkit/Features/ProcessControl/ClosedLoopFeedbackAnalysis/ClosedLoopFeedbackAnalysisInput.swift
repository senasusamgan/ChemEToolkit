struct ClosedLoopFeedbackAnalysisInput: Equatable, Sendable {
    let forwardPathGain: Double
    let feedbackPathGain: Double
    let referenceInput: Double
    let outputDisturbance: Double
}
