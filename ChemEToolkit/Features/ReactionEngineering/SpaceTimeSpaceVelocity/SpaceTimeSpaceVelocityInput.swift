struct SpaceTimeSpaceVelocityInput:
    Equatable,
    Sendable {

    let reactorVolume: Double
    let inletVolumetricFlowRate: Double
    let fluidHoldupFraction: Double
}
