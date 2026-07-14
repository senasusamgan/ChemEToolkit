struct PressureDropInput:
    Equatable,
    Sendable {

    let density: Double
    let averageVelocity: Double
    let pipeDiameter: Double
    let pipeLength: Double
    let dynamicViscosity: Double
    let absoluteRoughness: Double
    let gravity: Double

    init(
        density: Double,
        averageVelocity: Double,
        pipeDiameter: Double,
        pipeLength: Double,
        dynamicViscosity: Double,
        absoluteRoughness: Double,
        gravity: Double = 9.80665
    ) {
        self.density = density
        self.averageVelocity =
            averageVelocity
        self.pipeDiameter =
            pipeDiameter
        self.pipeLength =
            pipeLength
        self.dynamicViscosity =
            dynamicViscosity
        self.absoluteRoughness =
            absoluteRoughness
        self.gravity = gravity
    }
}
