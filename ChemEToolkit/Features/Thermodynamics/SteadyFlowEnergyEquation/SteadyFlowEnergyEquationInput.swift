struct SteadyFlowEnergyEquationInput: Equatable, Sendable {
    let massFlowRate: Double
    let shaftWorkRateByControlVolume: Double
    let inletEnthalpy: Double
    let outletEnthalpy: Double
    let inletVelocity: Double
    let outletVelocity: Double
    let inletElevation: Double
    let outletElevation: Double
}
