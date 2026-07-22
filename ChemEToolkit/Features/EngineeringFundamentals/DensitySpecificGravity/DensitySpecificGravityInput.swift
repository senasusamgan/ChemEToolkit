struct DensitySpecificGravityInput:
    Equatable,
    Sendable {

    let mass: Double
    let volume: Double
    let referenceDensity: Double
}
