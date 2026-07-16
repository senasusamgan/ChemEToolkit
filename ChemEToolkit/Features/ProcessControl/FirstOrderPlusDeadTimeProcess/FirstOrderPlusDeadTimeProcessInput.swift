struct FirstOrderPlusDeadTimeProcessInput:
    Equatable,
    Sendable {

    let initialOutput: Double
    let processGain: Double
    let inputStepChange: Double

    let timeConstant: Double
    let deadTime: Double
    let evaluationTime: Double
}
