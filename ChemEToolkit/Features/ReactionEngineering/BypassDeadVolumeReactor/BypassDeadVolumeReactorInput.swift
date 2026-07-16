struct BypassDeadVolumeReactorInput:
    Equatable,
    Sendable {

    let nominalReactorVolume: Double
    let totalVolumetricFlowRate:
        Double

    let deadVolumeFraction: Double
    let bypassFraction: Double

    let firstOrderRateConstant:
        Double
}
