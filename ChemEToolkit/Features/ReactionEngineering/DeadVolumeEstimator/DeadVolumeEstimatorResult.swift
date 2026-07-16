struct DeadVolumeEstimatorResult:
    Equatable,
    Sendable {

    let nominalSpaceTime: Double
    let measuredMeanResidenceTime:
        Double

    let activeVolume: Double
    let deadVolume: Double

    let activeVolumeFraction: Double
    let deadVolumeFraction: Double
    let residenceTimeRatio: Double

    let modelName: String
    let limitationDescription: String
}
