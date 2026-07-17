struct GasAbsorberBalanceResult:
    Equatable,
    Sendable {

    let inertGasMolarFlow: Double
    let outletGasMolarFlow: Double

    let inletSoluteMolarFlow:
        Double
    let outletSoluteMolarFlow:
        Double
    let absorbedSoluteMolarFlow:
        Double

    let soluteRemovalFraction:
        Double
    let gasFlowReductionFraction:
        Double

    let modelName: String
    let limitationDescription: String
}
