struct SecondOrderProcessResponseInput:
    Equatable,
    Sendable {

    let initialOutput: Double
    let processGain: Double
    let inputStepChange: Double

    let naturalFrequency: Double
    let dampingRatio: Double

    let evaluationTime: Double
}
