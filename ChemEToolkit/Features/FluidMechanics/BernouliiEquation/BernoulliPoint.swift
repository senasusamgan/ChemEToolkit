struct BernoulliPoint:
    Equatable,
    Sendable {

    let pressure: Double
    let velocity: Double
    let elevation: Double
    let kineticEnergyCorrectionFactor:
        Double

    init(
        pressure: Double,
        velocity: Double,
        elevation: Double,
        kineticEnergyCorrectionFactor:
            Double = 1
    ) {
        self.pressure = pressure
        self.velocity = velocity
        self.elevation = elevation
        self.kineticEnergyCorrectionFactor =
            kineticEnergyCorrectionFactor
    }
}
