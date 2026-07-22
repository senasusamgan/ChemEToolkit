struct PhaseChangeEnergyBalanceInput:
    Equatable,
    Sendable {

    let massFlowRate: Double
    let latentHeat: Double
    let phaseChangeFraction:
        Double
}
