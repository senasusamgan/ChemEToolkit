struct CentrifugeSigmaScaleUpInput: Equatable, Sendable {
    let referenceThroughput: Double
    let referenceSigmaFactor: Double
    let targetSigmaFactor: Double
    let efficiencyCorrection: Double
}
