struct IntegratingProcessResponseInput:
    Equatable,
    Sendable {

    let initialOutput: Double
    let integratingGain: Double
    let inputStepChange: Double

    let deadTime: Double
    let evaluationTime: Double

    let targetOutput: Double
}
