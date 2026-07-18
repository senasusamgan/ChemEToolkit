struct AbsorptionMinimumSolventRateInput: Equatable, Sendable {
    let gasMolarFlow: Double
    let inletGasSoluteFraction: Double
    let outletGasSoluteFraction: Double
    let inletLiquidSoluteFraction: Double
    let equilibriumSlope: Double
    let designFactor: Double
}
