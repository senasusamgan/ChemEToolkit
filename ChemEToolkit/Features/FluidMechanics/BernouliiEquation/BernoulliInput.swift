struct BernoulliInput:
    Equatable,
    Sendable {

    let density: Double
    let gravity: Double

    let inlet: BernoulliPoint

    let outletVelocity: Double
    let outletElevation: Double
    let outletKineticEnergyCorrectionFactor:
        Double

    let pumpHead: Double
    let turbineHead: Double
    let headLoss: Double

    init(
        density: Double,
        gravity: Double = 9.80665,
        inlet: BernoulliPoint,
        outletVelocity: Double,
        outletElevation: Double,
        outletKineticEnergyCorrectionFactor:
            Double = 1,
        pumpHead: Double = 0,
        turbineHead: Double = 0,
        headLoss: Double = 0
    ) {
        self.density = density
        self.gravity = gravity
        self.inlet = inlet
        self.outletVelocity =
            outletVelocity
        self.outletElevation =
            outletElevation
        self.outletKineticEnergyCorrectionFactor =
            outletKineticEnergyCorrectionFactor
        self.pumpHead = pumpHead
        self.turbineHead = turbineHead
        self.headLoss = headLoss
    }
}
