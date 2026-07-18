struct EvaporativeCrystallizerBalanceInput:
    Equatable,
    Sendable {

    let feedMassFlow: Double
    let feedSoluteMassFraction: Double
    let solventEvaporationFlow: Double
    let motherLiquorSoluteMassFraction: Double
    let crystalPurityFraction: Double
}
