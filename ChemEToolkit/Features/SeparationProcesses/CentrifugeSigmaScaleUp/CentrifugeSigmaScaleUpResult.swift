struct CentrifugeSigmaScaleUpResult: Equatable, Sendable {
    let sigmaRatio: Double
    let idealTargetThroughput: Double
    let correctedTargetThroughput: Double
    let throughputIncrease: Double
    let relativeCapacityGain: Double
    let modelName: String
    let limitationDescription: String
}
