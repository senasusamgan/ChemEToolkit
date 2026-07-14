struct FroudeNumberResult:
    Equatable,
    Sendable {

    let froudeNumber: Double
    let flowRegime:
        OpenChannelFlowRegime

    let averageVelocity: Double
    let hydraulicDepth: Double
    let gravityWaveCelerity: Double
}
