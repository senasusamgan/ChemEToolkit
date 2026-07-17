struct GasAbsorberBalanceInput:
    Equatable,
    Sendable {

    let inletGasMolarFlow: Double
    let inletSoluteMoleFraction:
        Double
    let outletSoluteMoleFraction:
        Double
}
