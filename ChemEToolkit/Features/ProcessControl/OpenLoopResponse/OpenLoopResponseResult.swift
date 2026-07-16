struct OpenLoopResponseResult: Equatable, Sendable {
    let requestedControllerOutput:
        Double
    let appliedControllerOutput:
        Double
    let appliedManipulatedChange:
        Double

    let openLoopGain: Double
    let processOutputAtEvaluationTime:
        Double
    let finalProcessOutput: Double

    let responseHasStarted: Bool
    let fractionOfFinalChange:
        Double

    let controllerIsSaturated:
        Bool

    let modelName: String
    let limitationDescription: String
}
