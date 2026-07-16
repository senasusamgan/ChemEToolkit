struct DeadVolumeEstimatorInput:
    Equatable,
    Sendable {

    let nominalReactorVolume: Double
    let volumetricFlowRate: Double
    let measuredMeanResidenceTime:
        Double
}
