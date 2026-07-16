struct IMCControllerTuningInput:
    Equatable,
    Sendable {

    let processGain: Double
    let processTimeConstant:
        Double
    let processDeadTime: Double

    let closedLoopTimeConstant:
        Double
}
