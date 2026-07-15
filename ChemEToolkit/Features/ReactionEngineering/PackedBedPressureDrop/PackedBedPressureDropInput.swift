struct PackedBedPressureDropInput:
    Equatable,
    Sendable {

    let fluidDensity: Double
    let fluidViscosity: Double
    let superficialVelocity: Double

    let particleDiameter: Double
    let bedVoidFraction: Double
    let bedLength: Double
}
