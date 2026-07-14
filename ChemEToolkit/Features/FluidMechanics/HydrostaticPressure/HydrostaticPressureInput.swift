struct HydrostaticPressureInput:
    Equatable,
    Sendable {

    let fluidDensity: Double
    let depth: Double
    let surfacePressure: Double
    let gravity: Double

    init(
        fluidDensity: Double,
        depth: Double,
        surfacePressure: Double,
        gravity: Double = 9.80665
    ) {
        self.fluidDensity = fluidDensity
        self.depth = depth
        self.surfacePressure = surfacePressure
        self.gravity = gravity
    }
}
