struct SingleStageGasAbsorptionResult:
    Equatable,
    Sendable {

    let outletGasSoluteFraction:
        Double
    let outletLiquidSoluteFraction:
        Double

    let soluteAbsorbedMolarFlow:
        Double
    let soluteRemovalFraction:
        Double

    let inletSoluteMolarFlow:
        Double
    let outletGasSoluteMolarFlow:
        Double
    let outletLiquidSoluteMolarFlow:
        Double

    let modelName: String
    let limitationDescription: String
}
