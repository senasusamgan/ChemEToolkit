struct ParticleSettlingResult:
    Equatable,
    Sendable {

    let signedTerminalVelocity: Double
    let terminalSpeed: Double
    let particleReynoldsNumber: Double
    let densityDifference: Double
    let motionDirection: ParticleMotionDirection

    let particleDiameter: Double
    let particleDensity: Double
    let fluidDensity: Double

    var isWithinStokesRegime: Bool {
        particleReynoldsNumber < 1
    }

    var terminalSpeedMillimetresPerSecond:
        Double {
        terminalSpeed * 1_000
    }
}
