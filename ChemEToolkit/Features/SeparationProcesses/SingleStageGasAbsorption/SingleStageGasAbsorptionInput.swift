struct SingleStageGasAbsorptionInput:
    Equatable,
    Sendable {

    let gasMolarFlow: Double
    let liquidMolarFlow: Double

    let inletGasSoluteFraction:
        Double
    let inletLiquidSoluteFraction:
        Double

    let equilibriumSlope: Double
}
