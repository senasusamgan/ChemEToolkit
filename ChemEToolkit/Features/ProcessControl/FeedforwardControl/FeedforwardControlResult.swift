struct FeedforwardControlResult: Equatable, Sendable {
    let idealManipulatedVariableChange:
        Double
    let requestedControllerOutput:
        Double
    let appliedControllerOutput:
        Double
    let appliedManipulatedVariableChange:
        Double

    let uncompensatedOutputChange:
        Double
    let residualOutputChange:
        Double
    let cancellationFraction:
        Double

    let controllerIsSaturated:
        Bool

    let modelName: String
    let limitationDescription: String
}
