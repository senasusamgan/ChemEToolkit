struct StrippingMinimumGasRateInput: Equatable, Sendable {
    let liquidMolarFlow: Double
    let inletLiquidSoluteFraction: Double
    let outletLiquidSoluteFraction: Double
    let enteringGasSoluteFraction: Double
    let equilibriumSlope: Double
    let designFactor: Double
}
