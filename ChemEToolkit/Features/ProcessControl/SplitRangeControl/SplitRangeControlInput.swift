struct SplitRangeControlInput:
    Equatable,
    Sendable {

    let controllerOutput: Double
    let minimumControllerOutput:
        Double
    let splitPoint: Double
    let maximumControllerOutput:
        Double

    let firstActuatorMinimum:
        Double
    let firstActuatorMaximum:
        Double

    let secondActuatorMinimum:
        Double
    let secondActuatorMaximum:
        Double
}
