struct ModelPredictiveControlResult: Equatable, Sendable {
    let predictionHorizonSteps: Int
    let unconstrainedInputMove: Double
    let appliedInputMove: Double
    let unconstrainedManipulatedInput: Double
    let appliedManipulatedInput: Double
    let predictedFirstStepOutput: Double
    let predictedHorizonOutput: Double
    let initialTrackingError: Double
    let predictedHorizonError: Double
    let objectiveValue: Double
    let inputConstraintIsActive: Bool
    let modelName: String
    let limitationDescription: String
}
