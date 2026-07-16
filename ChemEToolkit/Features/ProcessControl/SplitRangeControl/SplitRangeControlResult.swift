struct SplitRangeControlResult:
    Equatable,
    Sendable {

    let constrainedControllerOutput:
        Double

    let firstActuatorOpeningFraction:
        Double
    let secondActuatorOpeningFraction:
        Double

    let firstActuatorSignal:
        Double
    let secondActuatorSignal:
        Double

    let activeRangeDescription:
        String
    let controllerOutputWasLimited:
        Bool

    let modelName: String
    let limitationDescription: String
}
