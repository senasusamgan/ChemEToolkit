struct SmithPredictorInput:
    Equatable,
    Sendable {

    let initialOutput: Double
    let manipulatedVariableStep:
        Double

    let actualProcessGain: Double
    let actualTimeConstant: Double
    let actualDeadTime: Double

    let modelProcessGain: Double
    let modelTimeConstant: Double
    let modelDeadTime: Double

    let evaluationTime: Double
}
