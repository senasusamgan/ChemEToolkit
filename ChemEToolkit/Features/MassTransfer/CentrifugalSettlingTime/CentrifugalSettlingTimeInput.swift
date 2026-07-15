struct CentrifugalSettlingTimeInput:
    Equatable,
    Sendable {

    let particleDiameter: Double
    let particleDensity: Double
    let fluidDensity: Double
    let fluidViscosity: Double

    let rotationalSpeedRPM: Double
    let initialRadius: Double
    let finalRadius: Double
}
