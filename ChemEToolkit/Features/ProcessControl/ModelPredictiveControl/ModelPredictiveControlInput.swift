struct ModelPredictiveControlInput: Equatable, Sendable {
    let currentProcessOutput: Double
    let referenceSetpoint: Double
    let processGain: Double
    let processTimeConstant: Double
    let sampleTime: Double
    let predictionHorizonSteps: Double
    let moveSuppressionWeight: Double
    let previousManipulatedInput: Double
    let minimumManipulatedInput: Double
    let maximumManipulatedInput: Double
}
