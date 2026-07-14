struct TankDrainInput:
    Equatable,
    Sendable {

    let tankCrossSectionalArea: Double
    let orificeArea: Double
    let dischargeCoefficient: Double
    let initialLiquidHeight: Double
    let finalLiquidHeight: Double
    let gravity: Double

    init(
        tankCrossSectionalArea: Double,
        orificeArea: Double,
        dischargeCoefficient: Double,
        initialLiquidHeight: Double,
        finalLiquidHeight: Double,
        gravity: Double = 9.80665
    ) {
        self.tankCrossSectionalArea =
            tankCrossSectionalArea
        self.orificeArea = orificeArea
        self.dischargeCoefficient =
            dischargeCoefficient
        self.initialLiquidHeight =
            initialLiquidHeight
        self.finalLiquidHeight =
            finalLiquidHeight
        self.gravity = gravity
    }
}
