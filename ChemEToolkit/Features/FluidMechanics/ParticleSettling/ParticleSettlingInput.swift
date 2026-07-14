struct ParticleSettlingInput:
    Equatable,
    Sendable {

    let particleDensity: Double
    let fluidDensity: Double
    let particleDiameter: Double
    let dynamicViscosity: Double
    let gravity: Double

    init(
        particleDensity: Double,
        fluidDensity: Double,
        particleDiameter: Double,
        dynamicViscosity: Double,
        gravity: Double = 9.80665
    ) {
        self.particleDensity = particleDensity
        self.fluidDensity = fluidDensity
        self.particleDiameter = particleDiameter
        self.dynamicViscosity = dynamicViscosity
        self.gravity = gravity
    }
}
