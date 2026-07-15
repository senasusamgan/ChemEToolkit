struct RecyclePFRInput:
    Equatable,
    Sendable {

    let freshFeedConcentration: Double
    let freshVolumetricFlowRate: Double
    let reactorVolume: Double
    let firstOrderRateConstant: Double
    let recycleRatio: Double
}
