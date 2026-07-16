struct OpenLoopResponseInput: Equatable, Sendable {
    let initialProcessOutput: Double

    let controllerBias: Double
    let controllerGain: Double
    let referenceStepChange: Double

    let minimumControllerOutput: Double
    let maximumControllerOutput: Double

    let processGain: Double
    let processTimeConstant: Double
    let processDeadTime: Double

    let evaluationTime: Double
}
