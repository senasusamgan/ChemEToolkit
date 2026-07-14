struct MinorLossInput:
    Equatable,
    Sendable {

    let density: Double
    let averageVelocity: Double
    let lossCoefficients: [Double]
    let gravity: Double

    init(
        density: Double,
        averageVelocity: Double,
        lossCoefficients: [Double],
        gravity: Double = 9.80665
    ) {
        self.density = density
        self.averageVelocity =
            averageVelocity
        self.lossCoefficients =
            lossCoefficients
        self.gravity = gravity
    }
}
