struct PumpPowerInput:
    Equatable,
    Sendable {

    let density: Double
    let volumetricFlowRate: Double
    let pumpHead: Double
    let efficiency: Double
    let gravity: Double

    init(
        density: Double,
        volumetricFlowRate: Double,
        pumpHead: Double,
        efficiency: Double,
        gravity: Double = 9.80665
    ) {
        self.density = density
        self.volumetricFlowRate =
            volumetricFlowRate
        self.pumpHead = pumpHead
        self.efficiency = efficiency
        self.gravity = gravity
    }
}
