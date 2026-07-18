struct BatchSettlingAreaEstimateInput:
    Equatable,
    Sendable {

    let slurryVolumetricFlow: Double
    let designSettlingVelocity: Double
    let hydraulicSafetyFactor: Double
    let tankAspectRatio: Double
}
