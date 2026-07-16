struct FirstOrderProcessResponseInput:
    Equatable,
    Sendable {

    let initialOutput: Double
    let processGain: Double
    let inputStepChange: Double

    let timeConstant: Double
    let evaluationTime: Double
}
